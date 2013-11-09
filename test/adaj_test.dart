import 'package:unittest/unittest.dart';
import 'package:unittest/html_config.dart';
import 'package:adaj/adaj.dart' as http;

void main() {
  useHtmlConfiguration();

  test("Run Dartium with --disable-web-security option to disable Access-Control-Allow-Origin restriction", () {});

  String url = "http://httpbin.org";

  test("single success callback", () {
    http.get(url + "/get").done(expectAsync1((json) {
        expect(json["url"], "http://httpbin.org/get");
      })).go();
  });

  test("single error callback", () {
    http.get(url + "/gett").fail(expectAsync1((response) {})).go();
  });

  test("error callback is not called on success", () {
    http.get(url + "/get").fail(expectAsync1((response) {
        expect(false, "error callback should not be called on success");
      }, count: 0)).go();
  });

  test("success callback is not called on error", () {
    http.get(url + "/gett").done(expectAsync1((json) {
        expect(false, 'success callback should not be called on error');
      }, count: 0)).go();
  });

  test("always callback on success", () {
    http.get(url + "/get").done(expectAsync1((json) {
      expect(json["url"], "http://httpbin.org/get");
    })).go();
  });

  test("always callback on error", () {
    http.get(url + "/gett").fail(expectAsync1((response) {})).go();
  });

  test("callback chain", (){
    var success = expectAsync1((json) {
      expect(json["url"], "http://httpbin.org/get");
    }, count: 3);
    var error = expectAsync1((response) {}, count: 4);
    http.get(url + "/get").done(success).fail(error).done(success).always(error).always(success).go();
    http.get(url + "/gett").fail(error).fail(error).done(success).always(error).go();
  });

  test("sending post", () {
    Map data = {"one": 1, "two": 2};
    http.post(url + "/post", data).done(expectAsync1((json) {
      expect(json["url"], "http://httpbin.org/post");
      expect(json["json"]["one"], 1);
      expect(json["json"]["two"], 2);
    })).go();
  });

  test("sending put", () {
    Map data = {"one": 1, "two": 2};
    http.put(url + "/put", data).done(expectAsync1((json) {
      expect(json["url"], "http://httpbin.org/put");
      expect(json["json"]["one"], 1);
      expect(json["json"]["two"], 2);
    })).go();
  });

  test("delete", () {
    http.delete(url + "/delete").done(expectAsync1((json) {
      expect(json["url"], "http://httpbin.org/delete");
    })).go();
  });

  test("head", () {
    http.adaj(url + "/", method: "HEAD", data: {}).done(expectAsync1((json) {
      expect(json, {});
    })).go();
  });

  test("ajax function", () {
    var a = http.adaj(url, method: "HEAD", data: {});
    expect(a.url, url);
    expect(a.method, "HEAD");
    expect(a.data, {});
  });

  test("get function", ()  {
    var a = http.get(url);
    expect(a.url, url);
    expect(a.method, "GET");
    expect(a.data, null);
  });

  test("post function", () {
    Map data = {"test": "some"};
    var a = http.post(url, data);
    expect(a.url, url);
    expect(a.method, "POST");
    expect(a.data, data);
  });

  test("put function", () {
    Map data = {"test": "some"};
    var a = http.put(url, data);
    expect(a.url, url);
    expect(a.method, "PUT");
    expect(a.data, data);
  });

  test("delete function", ()  {
    var a = http.delete(url);
    expect(a.url, url);
    expect(a.method, "DELETE");
    expect(a.data, null);
  });
}