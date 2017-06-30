<?php
session_start();

function usuarioEstaLogado(){
    return isset($_SESSION['usuario_logado']);

}

function verificaUsuario(){
    if(!usuarioEstaLogado()){
    	$_SESSION["danger"] = "Você não tem acesso a esta funcionalidade";
        header('Location: ../index.php');
        die();
    }
} 

function usuarioLogado(){
	return $_SESSION['nome'];
}

function logaUsuario($usuario){
	$_SESSION['usuario_logado'] = utf8_encode($usuario['email']);
	$_SESSION['nome'] = utf8_encode($usuario['nome']);
	$_SESSION['idPessoa'] = $usuario['idPessoa'];
}

function logout(){
	session_destroy();
	session_start();
}