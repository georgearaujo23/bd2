     <?php
        require_once('../controller/controllerMatricula.php');
        $cmat = new ControllerMatricula();
	$turmas = Array();
	$turmas = $cmat->ListarProcessamentoMatricula();

    ?>
    <div class="bs-example" data-example-id="simple-table"> 
        <table class="table table-striped table-bordered"> 
            <caption>Tumas Ofertadas</caption> 
            <thead> 
                <tr> 
                <th>#</th> 
                <th>Disciplina</th> 
                <th> Aluno</th> 
                <th> Situação</th> 
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
                    <td><?= $turma['aluno'] ?></td> 
                    <td><?= $turma['situacao']?></td> 
                    
                    </tr> <tr> 
                </tr> 
            
    <?php
        $i++;
        endforeach
    ?>
            </tbody> 

        </table> 
    </div>
    
