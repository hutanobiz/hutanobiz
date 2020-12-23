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
  return _config[_baseUrl];
}

dynamic get imageUrl {
  return _config[_baseImageUrl];
}

dynamic get googleApiKey {
  return _config[_googleApiKey];
}

Map<String, dynamic> devConstants = {
  _baseUrl: "https://sa-dev.hutano.xyz/",
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
