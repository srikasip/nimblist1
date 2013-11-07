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



  $('#add_tag').click(function(){
    var tagLine = $('#text_add_tag').val();
    tagLine = $.trim(tagLine);
    var id = $('.item-selected').attr('id');
    id = id.replace('task_item_', '');
    if(tagLine!='')
    {
      tagLine = tagLine.replace('#', '');
      var newTags = tagLine.split(' ');
      if(newTags.length>0)
      {
        var newTag = "#" + newTags[0];
        $.ajax({
          url: 'tasks/add_tag',
          data: {'id': id, 'new_tag': newTag},
          type: 'POST',
          beforeSend: function(xhr){},
          success: function(result, status, xhr){
            $('#tagBox').append("<span class='badge pull-right'>"+newTag+"</span>");
            $('#text_add_tag').val('');
          },
          error: function(xhr, status, error){ alert("Failed to add a new Tag. Please refresh and try again later.");}
        });
      }
    }
  });


  $('#text_add_tag').keypress(function(e){
    if (e.keyCode == 13) {
      $('#add_tag').click();
      return false; // prevent the button click from happening
    }
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