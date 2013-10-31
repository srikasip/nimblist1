class EmailHandlerController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def post
    @tempObj = TempHoldTasks.new
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
      else
      end
      #if a response or a fwd, then get top level tags and store them with processed item tag
      #if a response is a first time, then parse for top level tags, and then get tags for each item
    end
    @tempObj.subject = params['subject']



    # get the "stripped" body of the message, i.e. without
    # the quoted part
    @tempObj.body = params["stripped-text"]

    # process all attachments:
    count = params['attachment-count'].to_i
    count.times do |i|
      stream = params["attachment-#{i+1}"]
      filename = stream.original_filename
      data = stream.read()
    end
    # Message parsed into broad objects
    if @tempObj.save()
      render 'Successful'
    else
      render 'Unsuccessful'
    end

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
      is_forward = false
      if subject.match(/^re:/i)
        is_forward = true
      elsif subject.match(/^fwd:/i)
        is_forward = true
      else
        is_forward = false
      end
      return is_forward
    end


    def get_username(email_id)
      handle = email_id.sub!(/@.*$/, "")
      return handle
    end

    def get_common_tags(email_text)
      tags = Array.new
      #parse the top lines for hashtags until we get to a line that has more than just hashtags
      email_text.scan(/.*/).each do |line|
        tempLine = line.sub!(/#\S*/, "")

        if tempLine.scan(/[A-Za-z0-9]/).count>0
          break
        else
          line.scan(/#\S*/).each do |tag|
            tags.push tag
          end
        end
      end

      return tags
    end

    def GetIndividualTags(email_text)

      return tags
    end

end
