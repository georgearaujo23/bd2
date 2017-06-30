<?php 
	include("classes/seguranca.php");

	logout();
	$_SESSION["success"]  = "Deslogado com sucesso";
	header("Location: index.php");