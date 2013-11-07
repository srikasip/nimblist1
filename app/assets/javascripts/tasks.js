//# Place all the behaviors and hooks related to the matching controller here.
//# All this logic will automatically be available in application.js.
//# You can use CoffeeScript in this file: http://coffeescript.org/


function LoadHandlers()
{
  $('.task_is_complete').on('change', function(){
     cb = $(this);

    var box_id = $(this).attr('id');
    var task_id = box_id.replace('task_','');

    $.ajax({
      url: 'tasks/change_status',
      data: {'id' : task_id},
      type: 'POST',
      beforeSend: function(xhr){
      },
      success: function(result, status, xhr){
        var link_name = 'text_task_' + task_id;
        if($(cb).is(':checked'))
        {
          $('#'+link_name).addClass('finished-task');
          $('#'+link_name).addClass('muted');
        }
        else
        {
          $('#'+link_name).removeClass('finished-task');
          $('#'+link_name).removeClass('muted');
        }
      },
      error: function(xhr, status, error){
        $(this).attr('checked', !($(this).is(':checked')));
        alert('Sorry, we failed to update your item.  Please refresh the page and try again later.  Thanks!');
      }
    });
  });
}


function CreateFlashMessage (myFlashType, myFlashMessage)
{
  var flash_type = '<div class="alert fade in';
  var flass_mess = '"><button class="close" data-dismiss="alert">&times;</button>';
  var flash_end = '</div>';
  var flash = flash_type + myFlashType + flash_mess + myFlashMessage + flash_end;

  return flash;
}

$(document).ready(function(){LoadHandlers();});
$(document).on('page:load', function(){LoadHandlers();});