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
  // return "https://dev.hutano.com/";
  // return "https://staging.hutano.com/";

  // return "https://production.hutano.com/";
  return "https://hutano.com/";
}

dynamic get imageUrl {
  // return "https://api.dev.hutano.com/";
  // return "https://80c99af3fc2f.ngrok.io/";
  // return "https://api.stage.hutano.com/";
  return "https://hutano-assets.s3.amazonaws.com/";
}

dynamic get googleApiKey {
  _config = devConstants;
  return _config[_googleApiKey];
}

Map<String, dynamic> devConstants = {
  _baseUrl: "https://api.stage.hutano.com/",
  _baseImageUrl: "https://sa-dev.hutano.xyz/uploads/",
  _googleApiKey: "AIzaSyAkq7DnUBTkddWXddoHAX02Srw6570ktx8"
};

Map<String, dynamic> stageConstants = {
  _baseUrl: "https://sa-staging.hutano.xyz/",
  _baseImageUrl: "https://sa-staging.hutano.xyz/uploads/",
  _googleApiKey: "AIzaSyAkq7DnUBTkddWXddoHAX02Srw6570ktx8"
};

Map<String, dynamic> prodConstants = {
  _baseUrl: "https://sa-staging.hutano.xyz/",
  _baseImageUrl: "https://sa-staging.hutano.xyz/uploads/",
  _googleApiKey: "AIzaSyAkq7DnUBTkddWXddoHAX02Srw6570ktx8"
};
