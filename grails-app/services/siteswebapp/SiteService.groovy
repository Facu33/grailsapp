package siteswebapp

import grails.converters.JSON
import grails.gorm.transactions.Transactional
import groovy.json.JsonSlurper

@Transactional
class SiteService {
    def conn;

    def getBrands() {
        def url = new URL("http://localhost:8080/brands")
        conn = (HttpURLConnection) url.openConnection()
        conn.setRequestMethod('GET')
        conn.setRequestProperty("Accept", "application/json")
        conn.setRequestProperty("User-Agent", "Mozilla/5.0")
        JsonSlurper json = new JsonSlurper()
        def brands = json.parse(conn.getInputStream())
        return brands
    }

    def getCategories(String id) {
        def url = new URL("http://localhost:8080/brands/" + id + "/items")
        conn = (HttpURLConnection) url.openConnection()
        conn.setRequestMethod('GET')
        conn.setRequestProperty("Accept", "application/json")
        conn.setRequestProperty("User-Agent", "Mozilla/5.0")
        JsonSlurper json = new JsonSlurper()
        def items = json.parse(conn.getInputStream())
        return items
    }

    def getCategorie(String id) {
        def url = new URL("http://localhost:8080/items/" + id)
        conn = (HttpURLConnection) url.openConnection()
        conn.setRequestMethod('GET')
        conn.setRequestProperty("Accept", "application/json")
        conn.setRequestProperty("User-Agent", "Mozilla/5.0")
        JsonSlurper json = new JsonSlurper()
        def categorie = json.parse(conn.getInputStream())
        return categorie
    }

    def deleteCategorie(String id) {
        def url = new URL("http://localhost:8080/items/" + id)
        conn = (HttpURLConnection) url.openConnection()
        conn.setRequestMethod('DELETE')
        conn.setRequestProperty("Accept", "application/json")
        conn.setRequestProperty("User-Agent", "Mozilla/5.0")
        conn.getInputStream()
        return "ok"
    }

    def newCategorie(String data) {
        println(data)
        def url = new URL("http://localhost:8080/items");
        conn = (HttpURLConnection) url.openConnection()
        conn.setDoOutput(true);
        conn.setDoInput(true);
        conn.setRequestProperty("Content-Type", "application/json");
        conn.setRequestProperty("Accept", "application/json");
        conn.setRequestMethod("POST");
        OutputStreamWriter wr = new OutputStreamWriter(conn.getOutputStream());
        wr.write(data);
        wr.flush();
        StringBuilder sb = new StringBuilder();
        JsonSlurper json = new JsonSlurper()
        def items = json.parse(conn.getInputStream())
        return items
    }


    def updateCategorie(String data, String id) {
        def url = new URL("http://localhost:8080/items/" + id);
        conn = (HttpURLConnection) url.openConnection()
        conn.setDoOutput(true);
        conn.setDoInput(true);
        conn.setRequestProperty("Content-Type", "application/json");
        conn.setRequestProperty("Accept", "application/json");
        conn.setRequestMethod("PUT");
        OutputStreamWriter wr = new OutputStreamWriter(conn.getOutputStream());
        wr.write(data);
        wr.flush();
        JsonSlurper json = new JsonSlurper()
        def items = json.parse(conn.getInputStream())
        return items
    }


}