<?php 
	include("dbconecta.php");
	include("../model/modelPessoa.php");
	include("seguranca.php");

	$usuario = buscarUsuario($conexao, $_POST['email'], $_POST['senha']);
	if($usuario == null){
		$_SESSION["danger"] = "Usuário ou senha inválido";
		header("Location: ../index.php");
	}else{
		logaUsuario($usuario);
		$_SESSION["success"] = "Usuário logado com sucesso!";
		header("Location: ../view/home.php");

	}

die();