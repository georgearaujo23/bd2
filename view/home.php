<?php 
	require_once('../classes/seguranca.php');
	require_once('../controller/controllerMatricula.php');
	
	verificaUsuario();
	$cmat = new ControllerMatricula();
	$solicitarMatricula = $cmat->verificarPeriodoMatricula();
?>

<html>
    <head>
        <title>Minha Loja</title>
        <meta charset="utf-8">
        <link href="../css/bootstrap.css" rel="stylesheet"/>
        <link href="../css/saif.css" rel="stylesheet"/>
          <!-- The jQuery library is a prerequisite for all jqSuite products -->
    <script type="text/ecmascript" src="../js/jquery.min.js"></script> 
    <!-- We support more than 40 localizations -->
    <script type="text/ecmascript" src="../js/trirand/i18n/grid.locale-en.js"></script>
    <!-- This is the Javascript file of jqGrid -->   
    <script type="text/ecmascript" src="../js/trirand/jquery.jqGrid.min.js"></script>
    <!-- A link to a Boostrap  and jqGrid Bootstrap CSS siles-->
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.4/css/bootstrap.min.css"> 
    <link rel="stylesheet" type="text/css" media="screen" href="../css/trirand/ui.jqgrid-bootstrap.css" />
	
    </head>
    
    <body>
        <div class="navbar navbar-inverse navbar-fixed-top">
            <div class="container">
                <div class="navbar-header">
                    <a href="#" class="navbar-brand">SAIF</a>
                </div>

                <div>
                    <ul class="nav navbar-nav navbar-right">
                        <li><a href="#"><span class="glyphicon glyphicon-user"></span> <?= $_SESSION["nome"]?></a></li>
                        <li><a href="../logout.php"><span class="glyphicon glyphicon-log-in"></span> Sair</a></li>
                    </ul>
                </div>
            </div><!-- container acaba aqui -->
        </div>
        
        <div class="container">
            <ul class="nav nav-tabs" id="myTabs" role="tablist"> 
                <li role="presentation" class="active">
                    <a href="#home" id="home-tab" role="tab" data-toggle="tab" aria-controls="home" aria-expanded="false">Home</a>
                </li> 
            </ul> 
        
            <div class="principal">
        
            <?php if(isset($_GET["success"])) { ?>
            <p class="alert-success"><?= $_GET["success"] ?></p>
            <?php } ?>

            <div class="tab-content" id="myTabContent"> 
                <div class="tab-pane fade active in" role="tabpanel" id="home" aria-labelledby="home-tab"> 
                    <div class="container">
                        <div class="row">
                            <div class="col-lg-5 col-md-5 col-sm-8 col-xs-9 bhoechie-tab-container">
                                <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3 bhoechie-tab-menu">
                                <div class="list-group">
                                    
                                    <a href="#" id="matricula" class="list-group-item text-center <?php print $solicitarMatricula ? 'active add-matricula' : 'disabled'?>" data-toggle="tab">
                                    <h4 class="glyphicon glyphicon-send"></h4><br/>Solicitar Matrícula
                                    </a>
                                    <a href="#" class="list-group-item text-center <?php print $solicitarMatricula ? ' add-processamento' : 'disabled'?>">
                                    <h4 class="glyphicon glyphicon-book"></h4><br/>Processar Matrícula
                                    </a>
                                    
                                    <a href="#" class="list-group-item text-center <?php print !$solicitarMatricula ? ' add-resultado' : 'disabled'?>">
                                    <h4 class="glyphicon glyphicon-check"></h4><br/>Resultado
                                    </a>
                                
                            </div>
                        </div>
                    </div>
                </div>
            </div> 
            
<script type="text/ecmascript"  src="../js/jquery.js"></script>
<script type="text/ecmascript"  src="../js/bootstrap.min.js"></script>
<script type="text/ecmascript" src="../js/saif.js"></script>
    

<?php include('../rodape.php');?>
