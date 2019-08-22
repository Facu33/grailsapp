package siteswebapp

import grails.converters.JSON
import grails.validation.ValidationException
import static org.springframework.http.HttpStatus.*

class SiteController {

    def siteService

    def index() {
        def brands = siteService.getBrands()
        [brands: brands]
    }

    def categories(String id) {
        def categories = siteService.getCategories(id)
        def result = [categories: categories]
        render result as JSON
    }

    def categorie(String id) {
        def categorie = siteService.getCategorie(id)
        def result = [categorie: categorie]
        render result as JSON
    }

    def deleteCategorie(String id) {
        def categorie = siteService.deleteCategorie(id)
        def result = [categorie: categorie]
        render result as JSON
    }

    def newCategorie(String data) {
        def item = siteService.newCategorie(data)
        println(item)
        def result = [item: item]
        render result as JSON

    }

    def updateCategorie(String data, String id) {
        def item = siteService.updateCategorie(data, id)
        def result = [item: item]
        render result as JSON

    }
}