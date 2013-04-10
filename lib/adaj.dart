library adaj;

import "dart:html";
import "dart:json" as json;

void adaj(String url, {String method: "GET", Map data: null, Function success: null, Function error: null}) {

  HttpRequest request = new HttpRequest();

  request.open(method, url);
  if (success != null) {
    request.onLoad.listen((event) {
      if ((request.status - 200) < 100) {
        print(request.status);
        success(request.responseText);
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

void get(String url, Function success) {
  adaj(url, success: success);
}

void post(String url, Map data, [Function success]) {
  adaj(url, method: "POST", data: data, success: success);
}

void put(String url, Map data, [Function success]) {
  adaj(url, method: "PUT", data: data, success: success);
}

void delete(String url, [Function success]) {
  adaj(url, method: "DELETE", success: success);
}