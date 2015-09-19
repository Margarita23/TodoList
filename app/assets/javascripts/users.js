$( document ).ready(function() {
  checkboxEvent('.checkbox_field input');
  addDatepicker('.datePick');
  dragDropTask('.task_list');
    /*Update task*/
    var pens = document.getElementsByClassName('pen_grey');
    for(var p=0;p<pens.length;p++){
        var oneOfPens = pens[p];
        updateTaskClickEvent(oneOfPens);
    }
});
//------------
function dragDropTask(point){
$(point).sortable({
    handle:'div.top_down',
    cancel:'',
    stop:function( event, ui ){
        $.ajax({
            url: '/list/'+$(this).attr('id').split('_')[2]+'/task/'+$(ui.item).attr('id').split('_')[1]+'/dragdrop/'+($(ui.item).index()+1),
            type: 'PUT'
        });
        
    }
});
}
function checkboxEvent(check){
    $(check).bind('change', function(){
    if (this.checked){
        $.ajax({
            url: '/list/'+$(this).parent().parent().parent().parent().parent().attr('id').split('_')[1]+'/task/'+this.value+'/done',
            type: 'PUT'
        });
    }
  });
}
function updateTaskClickEvent(oneOf){
    oneOf.addEventListener('click',function(){
        var tagInput = document.createElement('input');
        if(this.parentNode.previousElementSibling.children.length==0){
            var text = this.parentNode.previousElementSibling.innerHTML;
            tagInput.value = text;
            this.parentNode.previousElementSibling.innerHTML = '';
            this.parentNode.previousElementSibling.appendChild(tagInput);
            tagInput.focus();
            tagInput.addEventListener('keydown',function(e){
                if(e.keyCode==13){
                    var newText = this.value;
                    if(newText.trim()){
                        var parent = this.parentNode;
                        parent.removeChild(this);
                        parent.innerHTML = newText;
                        if(parent.parentNode.id){
                            var url = '/task/'+parent.parentNode.id.split('_')[1]+'/rename/'+newText;
                        }
                        else{
                        var url = '/list/'+parent.parentNode.parentNode.id.split('_')[1]+'/rename/'+newText;
                        }
                        $.ajax({
                            url: url,
                            type: 'PUT'
                        });
                    }
                }
            });
        }
    });
}
function addDatepicker(element){
    $( element ).datepicker({
      showOn: "button",
      buttonImage: "http://res.cloudinary.com/nmetau/image/upload/v1442645925/note_nlc358.png",
      buttonImageOnly: true,
      dateFormat: "yy-mm-dd",
      beforeShow: function(input,inst){
          if($(input).val()){
              var dateVal = $(input).val();
              console.log(dateVal);
            $( input ).datepicker( "setDate", dateVal );
          }
      },
      onSelect: function(date){
          $.ajax({
            url: '/list/'+$(this).parent().parent().parent().attr('id').split('_')[1]+'/updatedate/'+date,
            type: 'PUT'
        });
        }
    });
}
