const _baseUrl = "baseUrl";
const _baseImageUrl = "_baseImageUrll";
const _googleApiKey = "_googleApiKey";

enum Environment { dev, stage, prod }

Map<String, dynamic> _config;

void setEnvironment(Environment env) {
  switch (env) {
    case Environment.dev:
      _config = devConstants;
      break;
    case Environment.stage:
      _config = stageConstants;
      break;
    case Environment.prod:
      _config = prodConstants;
      break;
  }
}

dynamic get apiBaseUrl {
  // _config = devConstants;
  // return "http://2edb7d715014.ngrok.io/";
  return "https://api.stage.hutano.com/";
}

dynamic get imageUrl {
  // return "https://api.dev.hutano.com/";
    return "https://api.stage.hutano.com/";
    // return "https://api.stage.hutano.com/";
    // return "http://4725d5c73be1.ngrok.io/";
    // return "http://2edb7d715014.ngrok.io/";
}

dynamic get googleApiKey {
  _config = devConstants;
  return _config[_googleApiKey];
} 

Map<String, dynamic> devConstants = {
  _baseUrl: "https://api.stage.hutano.com/",
  _baseImageUrl: "https://sa-dev.hutano.xyz/uploads/",
  _googleApiKey: "AIzaSyB0oMSYks73MwXluaDyBXqG9u_SCaCFs-I"
};

Map<String, dynamic> stageConstants = {
  _baseUrl: "https://sa-staging.hutano.xyz/",
  _baseImageUrl: "https://sa-staging.hutano.xyz/uploads/",
  _googleApiKey: "AIzaSyB0oMSYks73MwXluaDyBXqG9u_SCaCFs-I"
};

Map<String, dynamic> prodConstants = {
  _baseUrl: "https://sa-staging.hutano.xyz/",
  _baseImageUrl: "https://sa-staging.hutano.xyz/uploads/",
  _googleApiKey: "AIzaSyB0oMSYks73MwXluaDyBXqG9u_SCaCFs-I"
};
