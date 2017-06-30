<?php 
	include('classes/seguranca.php');

?>

<html>
    <head>
        <title>Minha Loja</title>
        <meta charset="utf-8">
        <link href="css/bootstrap.css" rel="stylesheet"/>
        <link href="css/saif.css" rel="stylesheet"/>
    </head>
    
    <body>
        <div class="navbar navbar-inverse navbar-fixed-top">
            <div class="container">
                <div class="navbar-header">
                    <a href="index.php" class="navbar-brand">SAIF</a>
                </div>

                <div>
                    <ul class="nav navbar-nav">
                        <li><a href="produto-formulario.php">Adiciona Produto</a></li>
                        <li><a href="produto-lista.php">Listar Produtos</a></li>
                        <li><a href="sobre.php">Sobre</a></li>
                        
                    </ul>
                     <ul class="nav navbar-nav navbar-right">
                    <li><a href="#"><span class="glyphicon glyphicon-user"></span> <?= $_SESSION["nome"]?></a></li>
                    <li><a href="logout.php"><span class="glyphicon glyphicon-log-in"></span> Sair</a></li>
                    </ul>
                </div>
            </div><!-- container acaba aqui -->
        </div>
        
        <div class="container">
            <div class="principal">
