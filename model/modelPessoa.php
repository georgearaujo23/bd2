<?php 

function buscarUsuario($conexao, $email, $senha){
	$senha = md5($senha);

	$sql = "SELECT * FROM vw_usuario_logado WHERE email = '{$email}' AND senha = '{$senha}'";

	$resultado = mysqli_query($conexao, $sql);

	$usuario = mysqli_fetch_assoc($resultado);

	return $usuario;
}