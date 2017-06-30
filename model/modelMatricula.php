<?php 

    class ModelMatricula{
        
        public function processarMatricula($conexao){
      
            $sql = "CALL processarMatriculas()";
                if(!mysqli_query($conexao, $sql)){
                    return 0;
            }
            
            
            return 1;
            
        }
        
        public function matricular($conexao,$params, $idAluno){
            $params['ids'] = explode(',', $params['ids']);
            $sql = "delete from matricula
                    where idAluno = {$idAluno}";
                if(!mysqli_query($conexao, $sql)){
                    return 0;
                }
            foreach($params['ids'] as $idturma){
                $sql = "INSERT INTO matricula(dataSolicitacao, idAluno, idMatriculaSituacao, idTurma) 
                    VALUES(now(), {$idAluno}, 1, {$idturma})";
                if(!mysqli_query($conexao, $sql)){
                    return 0;
                }
            }
            
            return 1;
            
        }
        
        public function verificarPeriodoMatricula($conexao){
	
            $sql = "SELECT * FROM periodoMatricula WHERE inicio <= now() AND fim >= now() and processamento is null";

            $resultado = mysqli_query($conexao, $sql);

            $periodo = mysqli_fetch_assoc($resultado);

            return $periodo != null;
        }
        
        
        public function ListarProcessamentoMatricula($conexao){
            $sql = "SELECT 
                    tm.QTD_MATRICULAS,
                    tm.idTurma,
                    tm.capacidade,
                    tm.horario,
                    tm.localAula,
                    tm.ano,
                    tm.periodo,
                    tm.numero,
                    tm.nome,
                    tm.cargaHoraria,
                    tm.sigla,
                    tm.TIPO_TURMA,
                    ms.descricao AS situacao,
                    p.nome as aluno
                    
                    FROM vw_turmas_matricula tm
                    INNER JOIN matricula mat on mat.idTurma = tm.idTurma
                        INNER JOIN matriculaSituacao ms on ms.idMatriculaSituacao = mat.idMatriculaSituacao
                        INNER JOIN aluno a on a.idAluno = mat.idAluno
                            INNER JOIN pessoa p on p.idPessoa = a.idPessoa";
            
            $resultado = mysqli_query($conexao, $sql);

            

            $lastx = array();
            $i = 0;
            while($row_msg = mysqli_fetch_assoc($resultado))
            {
                $lastx[$i]['QTD_MATRICULAS'] 	=  utf8_encode($row_msg['QTD_MATRICULAS']);
                $lastx[$i]['idTurma'] 	= utf8_encode($row_msg['idTurma']);
                $lastx[$i]['capacidade']	= utf8_encode($row_msg['capacidade']);
                $lastx[$i]['horario'] = utf8_encode($row_msg['horario']);
                $lastx[$i]['localAula']	= utf8_encode($row_msg['localAula']);
                $lastx[$i]['ano']	= utf8_encode($row_msg['ano']);
                $lastx[$i]['periodo']	= utf8_encode($row_msg['periodo']);
                $lastx[$i]['numero'] = utf8_encode($row_msg['numero']);
                $lastx[$i]['nome'] = utf8_encode($row_msg['nome']);
                $lastx[$i]['cargaHoraria'] = utf8_encode($row_msg['cargaHoraria']);
                $lastx[$i]['sigla'] = utf8_encode($row_msg['sigla']);
                $lastx[$i]['TIPO_TURMA'] = utf8_encode($row_msg['TIPO_TURMA']);
                $lastx[$i]['aluno'] = utf8_encode($row_msg['aluno']);
                $lastx[$i]['situacao'] = utf8_encode($row_msg['situacao']);

                $i++;
            }
            
            return $lastx ;
        }
        
        public function ListarTurmasMatricula($conexao, $idPessoa){
            $sql = "SELECT 
                    tm.QTD_MATRICULAS,
                    tm.idTurma,
                    tm.capacidade,
                    tm.horario,
                    tm.localAula,
                    tm.ano,
                    tm.periodo,
                    tm.numero,
                    tm.nome,
                    tm.cargaHoraria,
                    tm.sigla,
                    tm.TIPO_TURMA,
                    SUM((CASE WHEN p.idPessoa is     null then 0 else 1 end)) AS matriculado
                    FROM vw_turmas_matricula tm
                    LEFT JOIN matricula mat on mat.idTurma = tm.idTurma
                        LEFT JOIN aluno a on a.idAluno = mat.idAluno
                            LEFT JOIN pessoa p on p.idPessoa = a.idPessoa AND p.idPessoa = {$idPessoa}
                    group by tm.QTD_MATRICULAS,
                    tm.idTurma,
                    tm.capacidade,
                    tm.horario,
                    tm.localAula,
                    tm.ano,
                    tm.periodo,
                    tm.numero,
                    tm.nome,
                    tm.cargaHoraria,
                    tm.sigla,
                    tm.TIPO_TURMA";
            
            $resultado = mysqli_query($conexao, $sql);

            

            $lastx = array();
            $i = 0;
            while($row_msg = mysqli_fetch_assoc($resultado))
            {
                $lastx[$i]['QTD_MATRICULAS'] 	=  utf8_encode($row_msg['QTD_MATRICULAS']);
                $lastx[$i]['idTurma'] 	= utf8_encode($row_msg['idTurma']);
                $lastx[$i]['capacidade']	= utf8_encode($row_msg['capacidade']);
                $lastx[$i]['horario'] = utf8_encode($row_msg['horario']);
                $lastx[$i]['localAula']	= utf8_encode($row_msg['localAula']);
                $lastx[$i]['ano']	= utf8_encode($row_msg['ano']);
                $lastx[$i]['periodo']	= utf8_encode($row_msg['periodo']);
                $lastx[$i]['numero'] = utf8_encode($row_msg['numero']);
                $lastx[$i]['nome'] = utf8_encode($row_msg['nome']);
                $lastx[$i]['cargaHoraria'] = utf8_encode($row_msg['cargaHoraria']);
                $lastx[$i]['sigla'] = utf8_encode($row_msg['sigla']);
                $lastx[$i]['TIPO_TURMA'] = utf8_encode($row_msg['TIPO_TURMA']);
                $lastx[$i]['matriculado'] = utf8_encode($row_msg['matriculado']);

                $i++;
            }
            
            return $lastx ;
        }
        
    }
