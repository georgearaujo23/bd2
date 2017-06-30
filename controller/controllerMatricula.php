<?php 
	require_once("../classes/dbconecta.php");
	require_once("../classes/seguranca.php");
        require_once('../model/modelMatricula.php');
        
        if(!empty($_GET['method'])){
            $c = new ControllerMatricula();
            
        }
	
	class  ControllerMatricula{
	
            protected $model;
            protected $conexao;
            
            private $action;
            private $task = false;
            private $method = false;
            protected $params = array();
            protected $dados = array();
            protected $requestParams;
            
            
            public function __construct ()
            {
                $this->requestParams = $_REQUEST;
                $this->setAction();
                $this->setParams();
                $this->setTask();
                $this->setMethod();
            
                
                $this->model = new ModelMatricula();
                $this->conexao = mysqli_connect("localhost", "root", "", "SIAF");
                $this->index();
                
            }
            
            protected function index()
            {
                $method = $this->getMethod();
                
                if(!empty($method)){
                    switch($method){
                        case 'ListarTurmasMatricula':
                            $this->ListarTurmasMatricula();
                            break;
                        case 'matricular':
                            $this->matricular();
                            break;
                        case 'processarMatricula':
                            $this->processarMatricula();
                            break;
                        default:
                            print "{success: false, msg: \"Acesso não permitido a: '{$method}'\"}";
                            break;
                    }
                }
            }
	
            public function verificarPeriodoMatricula(){
                return $this->model->verificarPeriodoMatricula($this->conexao);
                
            }
            
            
            public function ListarProcessamentoMatricula(){
                
                $dados = $this->model->ListarProcessamentoMatricula($this->conexao);
                return $dados;
            }
            
            public function processarMatricula(){
                
                    
                    if($this->model->processarMatricula($this->conexao)){
                        print "success: Operacao realizada com sucesso!";
                    }else{
                        
                        header('HTTP/1.1 888 Internal Server Error');
                        print $_SESSION['idPessoa'];
                        
                    }
                
                
            }
            
            
            public function matricular(){
                
                if($this->model->matricular($this->conexao,$this->params, $_SESSION['idPessoa'])){
                    print "success: Operacao realizada com sucesso!";
                }else{
                    
                     header('HTTP/1.1 777 Internal Server Error');
                    print $_SESSION['idPessoa'];
                    
                }
                
            }
            
            public function ListarTurmasMatricula(){
                
                $dados = $this->model->ListarTurmasMatricula($this->conexao, $_SESSION['idPessoa']);
                return $dados;
            }
            
            protected function getMethod()
            {
                return $this->method;
            }
            
            protected function getAction()
            {
                return $this->action;
            }
            
            private function setAction()
            {
                if(!empty($this->requestParams['action']) and is_string($this->requestParams['action'])){
                    $this->action = $this->requestParams['action'];
                }else{
                    $this->action = "index";
                }
            }


            private function setTask()
            {
                if(!empty($this->requestParams['task']) and is_string($this->requestParams['task'])){
                    $this->task = $this->requestParams['task'];
                }
            }


            private function setMethod()
            {
                if(!empty($this->requestParams['method']) and is_string($this->requestParams['method'])){
                    $this->method = $this->requestParams['method'];
                }
            }
            
            private function setParams()
            {
                $requestParams = $this->recursiveUTF8Decode($this->requestParams);
                $paramsPhpInput = $this->getParamsPhpInput();
                $this->params = array_merge($requestParams, $paramsPhpInput);
            }
            
            private function recursiveUTF8Decode($params)
            {
                if(is_array($params)){
                    foreach ($params as $chave => $valor){
                        if(is_array($valor)){
                            $params[$chave] = $this->recursiveUTF8Decode($valor);
                        }else{
                            $params[$chave] = utf8_decode($valor);
        //                    $params[$chave] = $valor;
                        }
                    }
                }
                
                return $params;
            }
            
            private function getParamsPhpInput()
            {
                $dadosInput = file_get_contents("php://input");
                
                $params = json_decode($dadosInput, true);
                
                if(empty($params)){
                    parse_str($dadosInput, $params);
                }
                
                $params = $this->recursiveUTF8Decode($params);

                return empty($params) ? array() : $params;
            }
            
               
	}