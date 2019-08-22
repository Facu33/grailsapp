<!doctype html>
<html>
<head>
    <title>Welcome to Grails</title>
    <script src="https://unpkg.com/vue"></script>
    <script src="https://unpkg.com/axios/dist/axios.min.js"></script>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap.min.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/js/bootstrap.min.js"></script>
</head>

<body>

<nav class="navbar navbar-inverse navbar-fixed-top">
    <div class="container-fluid">
        <div class="navbar-header">
            <a class="navbar-brand" href="#">Merca Libre</a>
        </div>
        <ul class="nav navbar-nav">
            <li>
                <button type="button" id="buttonCreate" style="display: none" class="btn btn-success"
                        onclick="showFormCreate(false);">Crear Articulo
                </button>
            </li>
        </ul>
    </div>
</nav>

<div id="sites" class="container" style="margin-top:50px">
    <select class="form-control" id="select" onchange="selectSites.fetchData();">
        <option value="" selected disabled hidden>
            Seleccione una marca
        </option>
        <g:each in="${brands}" var="brand">
            <option value="${brand?.id}">${brand?.name}</option>
        </g:each>
    </select>

    <div id="table" class="table-responsive" style="display: none">
        <table border="1" class="table">
            <thead>

            <caption id="tableTitle">
                <a href="#" id="categoryTag" onclick="backToCategories()">Categories</a>

            </caption>

            <tr>
                <td>Id</td>
                <td>Nombre</td>
            </tr>
            </thead>
            <tr v-for="categories in list">
                <td>
                    <a href="#" @click="getCategories(categories.id,categories.name)">
                        {{categories.id}}
                    </a>
                </td>
                <td>{{categories.name}}</td>
            </tr>
        </table>
    </div>

    <div id="myModal" class="modal fade" role="dialog">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <h4 class="modal-title" id="modalHeader"></h4>
                </div>

                <div class="modal-body">
                    <p id="idCategorie"></p>

                    <p id="items"></p>
                    <img id="image" alt="" height="100" width="100">
                </div>

                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Cerrar</button>
                    <button type="button" class="btn btn-danger" onclick="selectSites.deleteItem();">Borrar</button>
                    <button type="button" class="btn btn-primary" onclick="showFormCreate(true);">Actualizar</button>

                </div>

            </div>

        </div>
    </div>

    <div id="createItemModal" class="modal fade" role="dialog">
        <div class="modal-dialog">
            <div class="modal-content" style="padding: 25px">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <h4 class="modal-title" id="createItemModalHeader"></h4>
                </div>

                <form>
                    <div class="form-group">
                        <label for="inputName">Nombre</label>
                        <input required type="text" class="form-control" id="inputName" ref="inputName"
                               aria-describedby="emailHelp"
                               placeholder="Nombre...">
                    </div>

                    <div class="form-group">
                        <label for="inputPicture">Imagen</label>
                        <input required type="text" class="form-control" id="inputPicture" ref="inputPicture"
                               placeholder="Imagen...">
                    </div>

                    <div class="form-group">
                        <label for="totalItemsInput">Total</label>
                        <input required type="number" class="form-control" id="totalItemsInput" ref="totalItemsInput"
                               placeholder="Total...">
                    </div>
                    <button type="submit" @click.prevent="createItem()" class="btn btn-primary">Crear</button>
                </form>

                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Cerrar</button>
                </div>

            </div>

        </div>
    </div>
</div>

<script>
    var itemId;
    var isUpdating;
    var selectSites = new Vue({
        el: '#sites',
        data: {
            list: [],
        },
        methods: {
            fetchData: function () {
                var id = document.getElementById("select").value;
                if (id) {
                    document.getElementById("table").style.display = "block";
                    document.getElementById("buttonCreate").style.display = "block";
                    axios.get('/site/categories', {
                        params: {
                            id: id
                        }
                    }).then(function (response) {
                        console.log(response)
                        selectSites.list = response.data.categories;
                    }).catch(function (e) {
                        console.log(e.message);
                    })
                }
                ;
            },
            getCategories: function (id, name) {
                itemId = id;
                if (id) {
                    axios.get('/site/categorie', {
                        params: {
                            id: id
                        }
                    }).then(function (response) {
                        if (response.data.categorie.children_categories.length != 0) {
                            selectSites.list = response.data.categorie.children_categories;
                            var pathFromRoot = response.data.categorie.path_from_root;
                            document.getElementById("tableTitle").innerHTML = "<a href='#' id='categoryTag' onclick='backToCategories()'>Categories</a>";
                            for (var i = 0; i < pathFromRoot.length; i++) {
                                document.getElementById("tableTitle").innerHTML += "/" + "<a href='#' class='categories' id='categoriesTag' data='" + pathFromRoot[i].id + "' >" + pathFromRoot[i].name;
                            }
                            var elements = document.getElementsByClassName("categories");
                            for (var i = 0; i < elements.length; i++) {
                                elements[i].onclick = function (e) {
                                    var lastId = e.target.attributes[3].value;
                                    selectSites.getCategories(lastId, "")
                                }
                            }

                        } else {
                            var lastCategorie = response.data.categorie;
                            $(document).ready(function () {
                                $("#myModal").modal();
                                document.getElementById("modalHeader").innerHTML = lastCategorie.name;
                                document.getElementById("idCategorie").innerHTML = "id : " + lastCategorie.id;
                                document.getElementById("items").innerHTML = "Total de items : " + lastCategorie.total_items_in_this_category;
                                document.getElementById("image").src = lastCategorie.picture;
                            });
                        }
                    }).catch(function (e) {
                        console.log(e.message);
                    })
                }
                ;
            },
            deleteItem: function () {
                if (itemId) {
                    axios.get('/site/deleteCategorie', {
                        params: {
                            id: itemId
                        }
                    }).then(function (response) {
                        if (response.data.categorie == 'ok') {
                            $('#myModal').modal('hide');
                            document.getElementById("table").style.display = "none";
                            alert("Se borro con exito")
                        } else {
                            alert("Error al Borrar")
                        }
                    }).catch(function (e) {
                        console.log(e.message);
                    })
                }
                ;
            },
            createItem: function () {
                var data = {
                    "name": this.$refs.inputName.value,
                    "picture": this.$refs.inputPicture.value,
                    "total_items_in_this_category": parseInt(this.$refs.totalItemsInput.value),
                    "brand": parseInt(document.getElementById("select").value),
                }
                if(!isUpdating) {
                    axios.get('/site/newCategorie', {
                        params: {
                            data: data
                        }
                    }).then(function (response) {
                        console.log(response)
                    }).catch(function (e) {
                        console.log(e.message);
                    })
                }else{
                    this.updateItem(data)
                }
            },
            updateItem: function (data) {
                axios.get('/site/updateCategorie', {
                    params: {
                        data: data,
                        id:itemId
                    }
                }).then(function (response) {
                    console.log(response)
                }).catch(function (e) {
                    console.log(e.message);
                })
            }
        }
    });

    function backToCategories() {
        document.getElementById("tableTitle").innerHTML = "<a href='#' id='categoryTag' onclick='backToCategories()'> " + "Categories";
        selectSites.fetchData()
    }

    function showFormCreate(isUpdating) {
        this.isUpdating=isUpdating;
        $('#createItemModal').modal();
    }
</script>

</body>
</html>
