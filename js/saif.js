$(".nav-tabs").on("click", "a", function(e){
      e.preventDefault();
      $(this).tab('show');
    })

.on("click", "span", function () {
    var anchor = $(this).siblings('a');
    $(anchor.attr('href')).remove();
    $(this).parent().remove();
    $(".nav-tabs li").children('a').first().click();
});

$('.add-matricula').click(function(e) {
    if(!($('#tabmMatricula').length)){
        e.preventDefault();
        //var id = $(".nav-tabs").children().length; //think about it ;)
        //$(".nav-tabs").children()
        $('#home-tab').closest('li').after('<li><a href="#tabmMatricula">Matrícula</a><span>x</span></li>');
        $('.tab-content').append('<div class="tab-pane" id="tabmMatricula"></div>');
        
        $('#tabmMatricula').load('../view/matricula.php');
        
        
    }
});


$('.add-processamento').click(function(e) {
    if(!($('#tabmProcessamento').length)){
        e.preventDefault();
        //var id = $(".nav-tabs").children().length; //think about it ;)
        //$(".nav-tabs").children()
        $('#home-tab').closest('li').after('<li><a href="#tabmProcessamento">Processar Matrícula</a><span>x</span></li>');
        $('.tab-content').append('<div class="tab-pane" id="tabmProcessamento"></div>');
        
        $('#tabmProcessamento').load('../view/processamento.php');
        
        
    }
});


$('.add-resultado').click(function(e) {
    if(!($('#tabmresultado').length)){
        e.preventDefault();
        //var id = $(".nav-tabs").children().length; //think about it ;)
        //$(".nav-tabs").children()
        $('#home-tab').closest('li').after('<li><a href="#tabmresultado">Resultado Processamento Matrícula</a><span>x</span></li>');
        $('.tab-content').append('<div class="tab-pane" id="tabmresultado"></div>');
        
        $('#tabmresultado').load('../view/resultado.php');
        
        
    }
});


