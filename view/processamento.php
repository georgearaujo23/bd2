
                <button class="btn btn-primary" type="submit" onClick="processarMatricula()">Processar Matrícula</button>
    
    <script language=JavaScript>

        function processarMatricula ()
        {		
                        $.ajax({
                        url:'../controller/controllerMatricula.php?method=processarMatricula',
                        success: function (response) {
                            alert("Processamento Ralizado com Sucesso!");
                            location.reload();
                        },
                        error: function (xhr, ajaxOptions, thrownError) {
                            if(xhr.status == '888'){
                                alert("Ocorreu erro no processamento de matricula!!!");
                            }
                            
                            
                        }
                    });  
        }
 </script>