import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_profile.dart';
import '../models/project.dart';
import '../models/skill.dart';
import '../services/firestore_service.dart';
import '../models/education.dart';
import '../models/experience.dart';
import '../models/certificate.dart';

class PortfolioProvider with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isSetupComplete = false;
  bool get isSetupComplete => _isSetupComplete;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  UserProfile? _tempProfile;
  // [FIX] Added public getter for _tempProfile
  UserProfile? get tempProfile => _tempProfile;

  final List<Skill> _tempSkills = [];
  List<Skill> get tempSkills => _tempSkills;
  final List<Project> _tempProjects = [];
  List<Project> get tempProjects => _tempProjects;
  final List<Certificate> _tempCertificates = [];
  List<Certificate> get tempCertificates => _tempCertificates;
  final List<Education> _tempEducation = [];
  List<Education> get tempEducation => _tempEducation;
  final List<Experience> _tempExperience = [];
  List<Experience> get tempExperience => _tempExperience;

  UserProfile? _liveProfile;
  UserProfile? get liveProfile => _liveProfile;
  List<Skill> _liveSkills = [];
  List<Skill> get liveSkills => _liveSkills;
  List<Project> _liveProjects = [];
  List<Project> get liveProjects => _liveProjects;
  List<Education> _liveEducation = [];
  List<Education> get liveEducation => _liveEducation;
  List<Experience> _liveExperience = [];
  List<Experience> get liveExperience => _liveExperience;
  List<Certificate> _liveCertificates = [];
  List<Certificate> get liveCertificates => _liveCertificates;

  List<UserProfile> _publicProfiles = [];
  List<UserProfile> _filteredPublicProfiles = [];
  List<UserProfile> get publicProfiles => _filteredPublicProfiles;

  UserProfile? _viewedProfile;
  UserProfile? get viewedProfile => _viewedProfile;
  List<Skill> _viewedSkills = [];
  List<Skill> get viewedSkills => _viewedSkills;
  List<Project> _viewedProjects = [];
  List<Project> get viewedProjects => _viewedProjects;
  List<Education> _viewedEducation = [];
  List<Education> get viewedEducation => _viewedEducation;
  List<Experience> _viewedExperience = [];
  List<Experience> get viewedExperience => _viewedExperience;
  List<Certificate> _viewedCertificates = [];
  List<Certificate> get viewedCertificates => _viewedCertificates;

  void prepareForEditing() { 
    if (_liveProfile == null) return; 
    clearTemporaryData(); 
    _tempProfile = _liveProfile; 
    _tempSkills.addAll(_liveSkills); 
    _tempProjects.addAll(_liveProjects); 
    _tempEducation.addAll(_liveEducation); 
    _tempExperience.addAll(_liveExperience); 
    _tempCertificates.addAll(_liveCertificates); 
    // No need to call notifyListeners() here if UI updates are based on temp lists already
  }

  void clearTemporaryData() { 
    _tempProfile = null; 
    _tempSkills.clear(); 
    _tempProjects.clear(); 
    _tempCertificates.clear(); 
    _tempEducation.clear(); 
    _tempExperience.clear(); 
    // notifyListeners(); // Usually called by methods that use this, or not needed if UI clears based on null _tempProfile
  }

  // Method to clear only temporary certificates
  void clearTempCertificates() {
    _tempCertificates.clear();
    notifyListeners();
  }

  // [FIX] Modified to accept profilePictureUrl and call notifyListeners
  void updateTempProfile({
    required String fullName,
    required String headline,
    required String about,
    String? profilePictureUrl, // Added optional profilePictureUrl
  }) {
    final user = _auth.currentUser;
    if (user == null) return;

    _tempProfile = UserProfile(
      uid: user.uid,
      email: user.email!,
      fullName: fullName,
      headline: headline,
      about: about,
      // Use the provided URL, or fall back to the existing one in _tempProfile if any
      profilePictureUrl: profilePictureUrl ?? _tempProfile?.profilePictureUrl, 
    );
    notifyListeners(); // Added notifyListeners
  }

  void addTempSkill(Skill skill) { _tempSkills.add(skill); notifyListeners(); }
  void addTempProject(Project project) { _tempProjects.add(project); notifyListeners(); }
  void addTempCertificate(Certificate certificate) { _tempCertificates.add(certificate); notifyListeners(); }
  void addTempEducation(Education education) { _tempEducation.add(education); notifyListeners(); }
  void addTempExperience(Experience experience) { _tempExperience.add(experience); notifyListeners(); }

  // [FIX] Implemented remove methods
  void removeTempSkill(Skill skill) {
    _tempSkills.remove(skill);
    notifyListeners();
  }

  void removeTempProject(Project project) {
    _tempProjects.remove(project);
    notifyListeners();
  }

  void removeTempCertificate(Certificate certificate) {
    _tempCertificates.remove(certificate);
    notifyListeners();
  }

  void removeTempEducation(Education education) {
    _tempEducation.remove(education);
    notifyListeners();
  }

  void removeTempExperience(Experience experience) {
    _tempExperience.remove(experience);
    notifyListeners();
  }

  Future<bool> checkSetupStatus() async {
    final user = _auth.currentUser;
    if (user == null) { _isSetupComplete = false; return false; }
    final hasProfile = await _firestoreService.hasUserProfile(user.uid);
    _isSetupComplete = hasProfile;
    notifyListeners();
    return hasProfile;
  }

  Future<void> saveFullPortfolio() async {
    if (_tempProfile == null) return;
    _isLoading = true;
    notifyListeners();
    try {
      await _firestoreService.saveFullPortfolio(
        userProfile: _tempProfile!,
        skills: _tempSkills,
        projects: _tempProjects,
        education: _tempEducation,
        experience: _tempExperience,
        certificates: _tempCertificates,
      );
      _isSetupComplete = true;
      await fetchFullPortfolio(); // Refresh live data after saving
    } catch (e) {
      // Handle error, maybe set an error state
      debugPrint("Error saving portfolio: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchFullPortfolio() async {
    final user = _auth.currentUser;
    if (user == null) return;
    _isLoading = true;
    notifyListeners();
    try {
      final portfolioData = await _firestoreService.getFullPortfolio(user.uid);
      if (portfolioData != null) {
        _liveProfile = UserProfile.fromMap(portfolioData['profile'], user.uid);
        _liveSkills = (portfolioData['skills'] as List).map((s) => Skill.fromMap(s)).toList();
        _liveProjects = (portfolioData['projects'] as List).map((p) => Project.fromMap(p)).toList();
        _liveEducation = (portfolioData['education'] as List).map((e) => Education.fromMap(e)).toList();
        _liveExperience = (portfolioData['experience'] as List).map((e) => Experience.fromMap(e)).toList();
        _liveCertificates = (portfolioData['certificates'] as List).map((c) => Certificate.fromMap(c)).toList();
      }
    } catch (e) {
      debugPrint("Error fetching portfolio: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchPublicProfiles() async {
    _isLoading = true;
    notifyListeners();
    try {
      _publicProfiles = await _firestoreService.getPublicProfiles();
      _filteredPublicProfiles = List.from(_publicProfiles);
    } catch (e) {
      debugPrint("Error fetching public profiles: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void searchPublicProfiles(String query) {
    if (query.isEmpty) {
      _filteredPublicProfiles = List.from(_publicProfiles);
    } else {
      final lowerCaseQuery = query.toLowerCase();
      _filteredPublicProfiles = _publicProfiles.where((profile) {
        final nameMatch = profile.fullName.toLowerCase().contains(lowerCaseQuery);
        final headlineMatch = profile.headline.toLowerCase().contains(lowerCaseQuery);
        return nameMatch || headlineMatch;
      }).toList();
    }
    notifyListeners();
  }

  Future<void> fetchPortfolioForUser(String userId) async {
    _isLoading = true;
    _viewedProfile = null; _viewedSkills = []; _viewedProjects = [];
    _viewedEducation = []; _viewedExperience = []; _viewedCertificates = [];
    notifyListeners();
    try {
      final portfolioData = await _firestoreService.getFullPortfolio(userId);
      if (portfolioData != null) {
        _viewedProfile = UserProfile.fromMap(portfolioData['profile'], userId);
        _viewedSkills = (portfolioData['skills'] as List).map((s) => Skill.fromMap(s)).toList();
        _viewedProjects = (portfolioData['projects'] as List).map((p) => Project.fromMap(p)).toList();
        _viewedEducation = (portfolioData['education'] as List).map((e) => Education.fromMap(e)).toList();
        _viewedExperience = (portfolioData['experience'] as List).map((e) => Experience.fromMap(e)).toList();
        _viewedCertificates = (portfolioData['certificates'] as List).map((c) => Certificate.fromMap(c)).toList();
      }
    } catch (e) {
      debugPrint("Error fetching viewed user portfolio: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void userLoggedOut() {
    _isSetupComplete = false;
    _liveProfile = null; _liveSkills = []; _liveProjects = [];
    _liveEducation = []; _liveExperience = []; _liveCertificates = [];
    _publicProfiles = []; _filteredPublicProfiles = [];
    _viewedProfile = null; _viewedSkills = []; _viewedProjects = [];
    _viewedEducation = []; _viewedExperience = []; _viewedCertificates = [];
    clearTemporaryData(); // Ensure temp data is also cleared
    notifyListeners();
  }
}
