library adaj;

import "dart:html";
import "dart:json" as json;

typedef void RequestCallback(Map data);

void adaj(String url, {String method: "GET", Map data: null, RequestCallback success: null, Function error: null}) {

  HttpRequest request = new HttpRequest();

  request.open(method, url);
  if (success != null) {
    request.onLoad.listen((event) {
      if ((request.status - 200) < 100) {
        Map jsonData = request.responseText.isEmpty ? {} : json.parse(request.responseText);
        success(jsonData);
      } else if (error != null) {
        error();
      }
    });
  }

  if (data != null) {
    request.setRequestHeader("Content-Type", "application/json");
    request.send(json.stringify(data));
  } else {
    request.send();
  }

}

void get(String url, RequestCallback success, [Function error]) {
  adaj(url, success: success, error: error);
}

void post(String url, Map data, [RequestCallback success, Function error]) {
  adaj(url, method: "POST", data: data, success: success, error: error);
}

void put(String url, Map data, [RequestCallback success, Function error]) {
  adaj(url, method: "PUT", data: data, success: success, error: error);
}

void delete(String url, [RequestCallback success, Function error]) {
  adaj(url, method: "DELETE", success: success, error: error);
}