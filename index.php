<?php 
	include('cabecalho.php');
	include('classes/seguranca.php');

	if(isset($_SESSION["success"])){ ?>
		<p class="alert-success"><?= $_SESSION["success"]?></p>
<?php 
		unset($_SESSION["success"]);
	}elseif(isset($_SESSION["danger"])){?>
		<p class="alert-danger"><?= $_SESSION["danger"]?></p>
<?php 
		unset($_SESSION["danger"]);
	}
?>

        <?php
			if(usuarioEstaLogado()){
		?>
			<p class="alert-success">Usuario Logado como: <?= usuarioLogado()?></p>
			<a href="logout.php">deslogar</a>
		<?php }else{?>
		
		
                <div class="panel-heading">
                    <div class="panel-title text-center">Sistema Acadêmico do Instituto Federal - SAIF</div>
                </div>     

                <div style="padding-top:30px" class="panel-body">

                    <div style="display:none" class="alert alert-danger col-sm-12"></div>

                    <form name="loginForm" class="form-horizontal " action="classes/login.php" method="post">

                        <div style="margin-bottom: 15px" class="input-group">
                            <span class="input-group-addon"><i class="glyphicon glyphicon-envelope"></i></span>
                            <input class="form-control " name="email" placeholder="exemplo@exemplo.com" required="" type="text">                                        
                        </div>

                        <div style="margin-bottom: 15px" class="input-group">
                            <span class="input-group-addon"><i class="glyphicon glyphicon-lock"></i></span>
                            <input class="form-control " name="senha" placeholder="Senha" required="" type="password">
                        </div>

                        <div style="margin-top:10px" class="form-group">
                            <div class="col-sm-12 controls">
                                <button type="submit" class="btn btn-primary btn-block " aria-label="Menu de ações" >
                                    <i class="fa fa-spin fa-spinner " ></i>
                                    Entrar
                                </button>
                            </div>
                        </div>    
                    </form>     
                </div>
                
		<?php }?>
		
<?php include('rodape.php');?>
