library adaj;

import "dart:html";
import "dart:json" as json;

typedef void RequestCallback(var data);

Ajax adaj(String url, {String method: "GET", Map data: null}) {
  return new Ajax(url, method, data);
}

Ajax get(String url) {
  return adaj(url);
}

Ajax post(String url, Map data) {
  return adaj(url, method: "POST", data: data);
}

Ajax put(String url, Map data) {
  return adaj(url, method: "PUT", data: data);
}

Ajax delete(String url) {
  return adaj(url, method: "DELETE");
}

class Ajax {
  
  static const String JsonType = "application/json";
  
  final String url;
  final String method;
  final Map data;
  final List<RequestCallback> _succesCallbacks = [];
  final List<RequestCallback> _errorCallbacks = [];
  
  Ajax(this.url, this.method, this.data);
  
  void go() {
    HttpRequest request = new HttpRequest();

    request.open(method, url);
    request.onLoad.listen((event) {
        if (request.status < 400) {
          try {
            Map result = request.responseText.isEmpty ? {} : json.parse(request.responseText);
            _executeSuccess(result);
          } catch (e) {
            _executeError(request.responseText);
          }
        } else {
          _executeError(request.responseText);
        }
      });
    
    request.setRequestHeader("Accept", JsonType);

    if (data != null) {
      request.setRequestHeader("Content-Type", JsonType);
      request.send(json.stringify(data));
    } else {
      request.send();
    }
  }  
  
  Ajax done(RequestCallback callback) {
    _succesCallbacks.add(callback);
    return this;
  }
  
  Ajax fail(RequestCallback callback) {
    _errorCallbacks.add(callback);
    return this;
  }
  
  Ajax always(RequestCallback callback) {
    _succesCallbacks.add(callback);
    _errorCallbacks.add(callback);
    return this;
  }
  
  void _executeSuccess(data) {
    _succesCallbacks.forEach((callback) => callback(data));
  }
  
  void _executeError(responseText) {
    _errorCallbacks.forEach((callback) => callback(responseText));
  }
  
}  
  
