class EmailHandlerController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def post
    # process various message parameters:
    

    handle = get_username(params['recipient'])
    user = User.find_by_name(handle)
  
    
    if user
      #check if the email is a response or a fwd.
      if is_email_forward(params['subject'])
        item = params['subject'].sub!(/^re:/i, '')
        tags = get_common_tags(params['stripped-text'])
        task = Task.new
        task.create_task(user, item, tags)
        #redirect_to tasks_path, notice: 'Success: '+handle  
      else
        #redirect_to tasks_path, notice: 'Failed: '+handle
      end

      #if a response or a fwd, then get top level tags and store them with processed item tag
      #if a response is a first time, then parse for top level tags, and then get tags for each item

      return HttpResponse('OK')
    end



    # Message parsed into broad objects

    #-------------Different Email sending formats--------------#
    #1. A forwarded email with hash tags
    #2. A reply to email with hash tags
    #3. A list of tasks with ONE item (all tags in email refer to the item)
    #4. A list of tasks with MULTIPLE items
    #4a. One set of tags for all the items
    #4b. Each item has its own tags


    #Step 1: Get the User
    #Step 2: Decide on the Email Format
    #Step 3: Parse the Email

  end

  private

    def is_email_forward(subject)
      reg_for = /^re:|^fwd:|^fw:/i
      is_forward = false
      if reg_for.match(subject)
        is_forward = true
      else
        is_forward = false
      end
      return is_forward
    end


    def get_username(email_id)
      if email_id
        handle = email_id.gsub!(/@.*$/, "")
      else
        handle=''
      end
      return handle
    end

    def get_common_tags(email_text)
      tags = Array.new
      #parse the top lines for hashtags until we get to a line that has more than just hashtags
      if email_text
        email_text.scan(/.*/).each do |line|
          tempLine = line.gsub(/#\S*/, "")

          if tempLine.scan(/[A-Za-z0-9]/).count>0
            break
          else
            line.scan(/#\S*/).each do |tag|
              tags.push tag
            end
          end
        end
      end

      return tags
    end

    def GetIndividualTags(email_text)

      return tags
    end

end
