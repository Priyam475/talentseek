class SkillIcons {
  // A map of lowercase skill names to their icon URLs from icons8
  static const Map<String, String> _skillIconMap = {
    // Programming Languages
    'flutter': 'https://img.icons8.com/color/48/000000/flutter.png',
    'dart': 'https://img.icons8.com/color/48/000000/dart.png',
    'python': 'https://img.icons8.com/color/48/000000/python.png',
    'javascript': 'https://img.icons8.com/color/48/000000/javascript.png',
    'java': 'https://img.icons8.com/color/48/000000/java-coffee-cup-logo.png',
    'c++': 'https://img.icons8.com/color/48/000000/c-plus-plus-logo.png',
    'c#': 'https://img.icons8.com/color/48/000000/c-sharp-logo.png',
    'c': 'https://img.icons8.com/color/48/000000/c-programming.png',
    'typescript': 'https://img.icons8.com/color/48/000000/typescript.png',
    'php': 'https://img.icons8.com/officel/40/000000/php-logo.png',
    'ruby': 'https://img.icons8.com/color/48/000000/ruby-programming-language.png',
    'go': 'https://img.icons8.com/color/48/000000/golang.png',
    'rust': 'https://img.icons8.com/external-tal-revivo-color-tal-revivo/24/000000/external-rust-is-a-systems-programming-language-logo-color-tal-revivo.png',
    'swift': 'https://img.icons8.com/color/48/000000/swift.png',
    'kotlin': 'https://img.icons8.com/color/48/000000/kotlin.png',
    'scala': 'https://img.icons8.com/color/48/000000/scala.png',
    'r': 'https://img.icons8.com/color/48/000000/r-project.png',
    'matlab': 'https://img.icons8.com/color/48/000000/matlab.png',
    'perl': 'https://img.icons8.com/color/48/000000/perl.png',

    // Web Technologies
    'html': 'https://img.icons8.com/color/48/000000/html-5.png',
    'html5': 'https://img.icons8.com/color/48/000000/html-5--v1.png',
    'css': 'https://img.icons8.com/color/48/000000/css3.png',
    'css3': 'https://img.icons8.com/color/48/000000/css3.png',
    'sass': 'https://img.icons8.com/color/48/000000/sass.png',
    'less': 'https://img.icons8.com/windows/32/000000/less-logo.png',
    'bootstrap': 'https://img.icons8.com/color/48/000000/bootstrap.png',
    'tailwind css': 'https://img.icons8.com/color/48/000000/tailwindcss.png',
    'webpack': 'https://img.icons8.com/color/48/000000/webpack.png',

    // Frameworks & Libraries
    'react': 'https://img.icons8.com/color/48/000000/react-native.png',
    'react native': 'https://img.icons8.com/color/48/000000/react-native.png',
    'vue.js': 'https://img.icons8.com/color/48/000000/vue-js.png',
    'angular': 'https://img.icons8.com/color/48/000000/angularjs.png',
    'svelte': 'https://img.icons8.com/doodle/48/000000/svetle.png',
    'next.js': 'https://img.icons8.com/color/48/000000/nextjs.png',
    'nuxt.js': 'https://img.icons8.com/color/48/000000/nuxt-js.png',
    'express.js': 'https://img.icons8.com/color/48/000000/express-js.png',
    'node.js': 'https://img.icons8.com/color/48/000000/nodejs.png',
    'django': 'https://img.icons8.com/color/48/000000/django.png',
    'flask': 'https://img.icons8.com/color/48/000000/flask.png',
    'laravel': 'https://img.icons8.com/fluency/48/000000/laravel.png',
    'spring': 'https://img.icons8.com/color/48/000000/spring-logo.png',
    'spring boot': 'https://img.icons8.com/color/48/000000/spring-logo.png',
    'fastapi': 'https://img.icons8.com/color/48/000000/fastapi.png',
    'rails': 'https://img.icons8.com/color/48/000000/ruby-on-rails.png',
    'asp.net': 'https://img.icons8.com/color/48/000000/net-framework.png',

    // Mobile Development
    'android': 'https://img.icons8.com/color/48/000000/android-os.png',
    'ios': 'https://img.icons8.com/color/48/000000/ios-logo.png',
    'xamarin': 'https://img.icons8.com/color/48/000000/xamarin.png',
    'ionic': 'https://img.icons8.com/color/48/000000/ionic.png',
    'cordova': 'https://img.icons8.com/color/48/000000/cordova.png',

    // Databases
    'sql': 'https://img.icons8.com/color/48/000000/sql.png',
    'mysql': 'https://img.icons8.com/color/48/000000/mysql-logo.png',
    'postgresql': 'https://img.icons8.com/color/48/000000/postgreesql.png',
    'mongodb': 'https://img.icons8.com/color/48/000000/mongodb.png',
    'sqlite': 'https://img.icons8.com/color/48/000000/sqlite.png',
    'redis': 'https://img.icons8.com/color/48/000000/redis.png',
    'cassandra': 'https://img.icons8.com/color/48/000000/cassandra.png',
    'elasticsearch': 'https://img.icons8.com/color/48/000000/elasticsearch.png',
    'firebase': 'https://img.icons8.com/color/48/000000/firebase.png',
    'firestore': 'https://img.icons8.com/color/48/000000/firebase.png',
    'oracle': 'https://img.icons8.com/color/48/000000/oracle-logo.png',

    // Cloud & DevOps
    'aws': 'https://img.icons8.com/color/48/000000/amazon-web-services.png',
    'azure': 'https://img.icons8.com/color/48/000000/azure-1.png',
    'google cloud': 'https://img.icons8.com/color/48/000000/google-cloud.png',
    'gcp': 'https://img.icons8.com/color/48/000000/google-cloud.png',
    'heroku': 'https://img.icons8.com/color/48/000000/heroku.png',
    'netlify': 'https://img.icons8.com/external-tal-revivo-shadow-tal-revivo/24/000000/external-netlify-a-cloud-computing-company-that-offers-hosting-and-serverless-backend-services-for-static-websites-logo-shadow-tal-revivo.png',
    'vercel': 'https://img.icons8.com/color/48/000000/vercel.png',
    'digitalocean': 'https://img.icons8.com/color/48/000000/digitalocean.png',

    // DevOps & Tools
    'docker': 'https://img.icons8.com/color/48/000000/docker.png',
    'kubernetes': 'https://img.icons8.com/color/48/000000/kubernetes.png',
    'jenkins': 'https://img.icons8.com/color/48/000000/jenkins.png',
    'gitlab': 'https://img.icons8.com/color/48/000000/gitlab.png',
    'github': 'https://img.icons8.com/color/48/000000/github--v1.png',
    'git': 'https://img.icons8.com/color/48/000000/git.png',
    'bitbucket': 'https://img.icons8.com/color/48/000000/bitbucket.png',
    'travis ci': 'https://img.icons8.com/color/48/000000/travis-ci.png',
    'circleci': 'https://img.icons8.com/color/48/000000/circleci.png',
    'terraform': 'https://img.icons8.com/color/48/000000/terraform.png',
    'ansible': 'https://img.icons8.com/color/48/000000/ansible.png',

    // Testing
    'jest': 'https://img.icons8.com/external-tal-revivo-color-tal-revivo/24/000000/external-jest-can-collect-code-coverage-information-from-entire-projects-logo-color-tal-revivo.png',
    'cypress': 'https://img.icons8.com/color/48/000000/cypress.png',
    'selenium': 'https://img.icons8.com/color/48/000000/selenium-test-automation.png',
    'junit': 'https://img.icons8.com/external-tal-revivo-color-tal-revivo/24/000000/external-junit-a-unit-testing-framework-for-java-programming-language-logo-color-tal-revivo.png',
    'mocha': 'https://img.icons8.com/color/48/000000/mocha.png',

    // Design & UI/UX
    'figma': 'https://img.icons8.com/color/48/000000/figma--v1.png',
    'adobe xd': 'https://img.icons8.com/color/48/000000/adobe-xd--v1.png',
    'sketch': 'https://img.icons8.com/color/48/000000/sketch.png',
    'invision': 'https://img.icons8.com/color/48/000000/invision.png',
    'zeplin': 'https://img.icons8.com/color/48/000000/zeplin.png',
    'photoshop': 'https://img.icons8.com/color/48/000000/adobe-photoshop--v1.png',
    'illustrator': 'https://img.icons8.com/color/48/000000/adobe-illustrator--v1.png',
    'after effects': 'https://img.icons8.com/color/48/000000/adobe-after-effects--v1.png',
    'premiere pro': 'https://img.icons8.com/color/48/000000/adobe-premiere-pro--v1.png',

    // IDEs & Editors
    'vscode': 'https://img.icons8.com/color/48/000000/visual-studio-code-2019.png',
    'visual studio': 'https://img.icons8.com/color/48/000000/visual-studio--v1.png',
    'intellij': 'https://img.icons8.com/color/48/000000/intellij-idea.png',
    'eclipse': 'https://img.icons8.com/color/48/000000/eclipse-ide.png',
    'android studio': 'https://img.icons8.com/color/48/000000/android-studio--v3.png',
    'xcode': 'https://img.icons8.com/color/48/000000/xcode.png',
    'sublime text': 'https://img.icons8.com/color/48/000000/sublime-text.png',
    'atom': 'https://img.icons8.com/color/48/000000/atom-editor.png',
    'vim': 'https://img.icons8.com/color/48/000000/vim.png',

    // Build Tools & Package Managers
    'npm': 'https://img.icons8.com/color/48/000000/npm.png',
    'yarn': 'https://img.icons8.com/color/48/000000/yarn.png',
    'gradle': 'https://img.icons8.com/color/48/000000/gradle.png',
    'maven': 'https://img.icons8.com/color/48/000000/maven-ios.png',
    'composer': 'https://img.icons8.com/color/48/000000/composer.png',
    'pip': 'https://img.icons8.com/color/48/000000/pip.png',

    // API & Communication
    'graphql': 'https://img.icons8.com/color/48/000000/graphql.png',
    'rest api': 'https://img.icons8.com/color/48/000000/api.png',
    'postman': 'https://img.icons8.com/color/48/000000/postman-api.png',
    'swagger': 'https://img.icons8.com/color/48/000000/swagger.png',
    'insomnia': 'https://img.icons8.com/color/48/000000/insomnia.png',

    // Analytics & Monitoring
    'google analytics': 'https://img.icons8.com/color/48/000000/google-analytics.png',
    'mixpanel': 'https://img.icons8.com/color/48/000000/mixpanel.png',
    'sentry': 'https://img.icons8.com/color/48/000000/sentry.png',
    'datadog': 'https://img.icons8.com/color/48/000000/datadog.png',
    'new relic': 'https://img.icons8.com/color/48/000000/new-relic.png',

    // Communication & Collaboration
    'slack': 'https://img.icons8.com/color/48/000000/slack-new.png',
    'discord': 'https://img.icons8.com/color/48/000000/discord--v2.png',
    'teams': 'https://img.icons8.com/color/48/000000/microsoft-teams.png',
    'zoom': 'https://img.icons8.com/color/48/000000/zoom.png',
    'jira': 'https://img.icons8.com/color/48/000000/jira.png',
    'confluence': 'https://img.icons8.com/color/48/000000/confluence.png',
    'notion': 'https://img.icons8.com/color/48/000000/notion--v1.png',
    'trello': 'https://img.icons8.com/color/48/000000/trello.png',

    // Operating Systems
    'windows': 'https://img.icons8.com/color/48/000000/windows-10.png',
    'macos': 'https://img.icons8.com/color/48/000000/mac-os--v1.png',
    'linux': 'https://img.icons8.com/color/48/000000/linux--v1.png',
    'ubuntu': 'https://img.icons8.com/color/48/000000/ubuntu--v1.png',
    'centos': 'https://img.icons8.com/color/48/000000/centos.png',
    'debian': 'https://img.icons8.com/color/48/000000/debian.png',

    // Blockchain & Web3
    'ethereum': 'https://img.icons8.com/color/48/000000/ethereum.png',
    'bitcoin': 'https://img.icons8.com/color/48/000000/bitcoin--v1.png',
    'solidity': 'https://img.icons8.com/color/48/000000/solidity.png',
    'web3': 'https://img.icons8.com/color/48/000000/web3.png',

    // Game Development
    'unity': 'https://img.icons8.com/color/48/000000/unity.png',
    'unreal engine': 'https://img.icons8.com/color/48/000000/unreal-engine.png',
    'godot': 'https://img.icons8.com/color/48/000000/godot.png',

    // Others
    'raspberry pi': 'https://img.icons8.com/color/48/000000/raspberry-pi.png',
    'arduino': 'https://img.icons8.com/color/48/000000/arduino.png',
    'pandas': 'https://img.icons8.com/color/48/000000/pandas.png',
    'numpy': 'https://img.icons8.com/color/48/000000/numpy.png',
    'jupyter': 'https://img.icons8.com/color/48/000000/jupyter.png',
    'tensorflow': 'https://img.icons8.com/color/48/000000/tensorflow.png',
    'pytorch': 'https://img.icons8.com/color/48/000000/pytorch.png',
    'opencv': 'https://img.icons8.com/color/48/000000/opencv.png',
  };

  // Default icon for unknown skills
  static const String _defaultIcon = 'https://img.icons8.com/color/48/000000/new-by-copy.png';

  /// Returns an icon URL for a given skill name.
  /// It performs a case-insensitive lookup.
  /// If the skill is not found, it returns a default icon URL.
  static String getIconForSkill(String skillName) {
    return _skillIconMap[skillName.toLowerCase()] ?? _defaultIcon;
  }

  /// Returns all available skill names
  static List<String> getAllSkills() {
    return _skillIconMap.keys.toList();
  }

  /// Checks if a skill icon exists in the map
  static bool hasSkill(String skillName) {
    return _skillIconMap.containsKey(skillName.toLowerCase());
  }
}
