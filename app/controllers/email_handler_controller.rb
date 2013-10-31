class EmailHandlerController < ApplicationController
  skip_before_filter :verify_authenticity_token

  respond_to :html, :xml, :json

  def post
    # process various message parameters:
    

    handle = get_username(params['recipient'])
    user = User.find_by_name(handle)
  
    
    if user
      #check if the email is a response or a fwd.
      if is_email_forward(params['subject'])
        item = params['subject'].gsub(/^re:|^fw:|^fwd:/i, '')
        item = item.squish
        tags = get_common_tags(params['stripped-text'])
        task = Task.new
        task.create_task(user, item, tags)
      else
        base_tags = get_common_tags(params['stripped-text'])
        #for line_items, the first element is the item.  All subsequent elements are tags.
        line_items = get_line_items(params['stripped-text'])
        line_items.each do |line_item|
          if line_item
            tags = Array.new
            task = Task.new
            item = line_item[0]
            if line_item.length>0
              line_item = line_item.from(1)
            else
              line_item = Array.new
            end
            tags = base_tags + line_item
            task.create_task(user, item, tags)
          end
        end      
      end

      #if a response or a fwd, then get top level tags and store them with processed item tag
      #if a response is a first time, then parse for top level tags, and then get tags for each item

      Mailgun.create(:subject => params['subject'], :sender => params['sender'], :recipient => params['recipient'], :stripped_text => params['stripped-text'], :body_plain => params['body-plain'])
      
      render :text=>'Success', :status=>:ok

    end
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

    def get_line_items(email_text)
      items = Array.new
      if email_text
        email_text.scan(/.*/).each do |line|
          tempLine = line.gsub(/#\S*/, "")

          if tempLine.scan(/[A-Za-z0-9]/).count>0
            items.push tempLine.squish
            
            line.scan(/#\S*/).each do |tag|
              items.push tag
            end
          end
        end
      end

      return items
    end

end
