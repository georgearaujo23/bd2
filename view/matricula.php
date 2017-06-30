     <?php
        require_once('../controller/controllerMatricula.php');
        $cmat = new ControllerMatricula();
	$turmas = Array();
	$turmas = $cmat->ListarTurmasMatricula();

    ?>
    <div class="bs-example" data-example-id="simple-table"> 
        <table class="table table-striped table-bordered"> 
            <caption>Tumas Ofertadas</caption> 
            <thead> 
                <tr> 
                <th>#</th> 
                <th>Disciplina</th> 
                <th> Turma</th> 
                <th> Horário</th> 
                <th> Vagas</th> 
                <th> Solicitações de Matrícula</th> 
                <th> </th> 
                </tr> 
            </thead> 
            <tbody> 
    <?php
        $i = 1;
        foreach($turmas AS $turma):
    ?>
                
                <tr> 
                    <th scope="row"><?= $i ?></th> 
                    <td><?= $turma['nome'] ?></td> 
                    <td><?= $turma['numero'] ?></td> 
                    <td><?= $turma['horario']?></td> 
                    <td><?= $turma['capacidade']?></td> 
                    <td><?= $turma['QTD_MATRICULAS'] ?></td> 
                    <td><input id="mat" type="checkbox" name="matricular" <?php print $turma['matriculado'] ? "checked='true'": ""?> value="<?= $turma['idTurma'] ?>"/></td>
                    </tr> <tr> 
                </tr> 
            
    <?php
        $i++;
        endforeach
    ?>
            </tbody> 
            <tfooter><button class="btn btn-primary" type="submit" onClick="matricular()">Matricular</button></tfooter>
        </table> 
    </div>
    
    <script language=JavaScript>

function matricular ()
{
		var inputs = document.getElementsByTagName('input')
		var qtd = Array();
		for (i=0;i<inputs.length;i++)
		{
			if (inputs[i].type=="checkbox" && inputs[i].checked==true )
			{
				qtd.push(inputs[i].value);
			}
		}		
		$.ajax({
                url:'../controller/controllerMatricula.php?method=matricular&ids=' + qtd,
                success: function (response) {
                    alert("Matrícula Ralizada com Sucesso!");
                    location.reload();
                },
                error: function (xhr, ajaxOptions, thrownError) {
                    if(xhr.status == '777'){
                        alert("Não é possível fazer duas matrículas para mesma disciplina!!!");
                    }else{
                        alert("Erro ao realizar a matrícula!");
                    }
                    
                    
                }
            });  
}
 </script>