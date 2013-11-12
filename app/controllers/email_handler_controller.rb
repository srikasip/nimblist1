class EmailHandlerController < ApplicationController
  skip_before_filter :verify_authenticity_token

  respond_to :html, :xml, :json

  def post
    # process various message parameters:

    #puts "--------------------------------Inside Post method"

    #mailgun = params['mailgun']    

    handle = get_username(params['recipient'])
    #handle = get_username(mailgun['recipient'])
    user = User.find_by_name(handle)

    if user
      #check if the email is a response or a fwd.

      #puts "--------------------------------Found my User....has id: " + user.id.to_s
      if is_email_forward(params['subject'])
      #if is_email_forward(mailgun['subject'])
        puts "--------------------------------Email is a forward "
        #if a response or a fwd, then get top level tags and store them with processed item tag
        item = params['subject'].gsub(/^re:|^fw:|^fwd:/i, '')
        #item = mailgun['subject'].gsub(/^re:|^fw:|^fwd:/i, '')
        item = item.squish
        tags = get_common_tags(params['stripped-text'])
        #tags = get_common_tags(mailgun['stripped_text'])
        task = Task.new
        task.create_task(user, item, tags)
      else
        puts "--------------------------------Email is not a forward "
        #if a response is a first time, then parse into buckets and parse each bucket into top level tags, and then get tags for each item
        buckets = get_buckets(params['stripped-text'])
        #buckets = get_buckets(mailgun['stripped_text'])
        buckets.each do |bucket|
          base_tags = Array.new
          line_items = Array.new
          
          base_tags = get_common_tags(bucket)
          line_items = get_line_items(bucket)
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
      end


      Mailgun.create(:subject => params['subject'], :sender => params['sender'], :recipient => params['recipient'], :stripped_text => params['stripped-text'], :body_plain => params['body-plain'])
      #Mailgun.create(:subject => mailgun['subject'], :sender => mailgun['sender'], :recipient => mailgun['recipient'], :stripped_text => mailgun['stripped-text'], :body_plain => mailgun['body-plain'])
      redirect_to :forward_on_email
      #render :text=>'Success', :status=>:ok
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

    def get_buckets(email_text)
      buckets = Array.new
      block = ""
      inTagBlock = false

      if email_text
        #if i'm in a block and i come to a tag-center, then break the last block and start the new block

        #break email into lines
        email_text.scan(/.*/).each do |line|
          #take out tags and check if line is empty
          line = line.squish
          tempLine = line.gsub(/#\S*/, "")
          tempLine = tempLine.squish
          #check if its a tag header
          if tempLine.scan(/[A-Za-z0-9]/).count>0
            puts "in Content Line: " + line
            inTagBlock = false
            block = block + "\r\n" + line

          elsif line == ""
            puts 'blank line: ' + line
          else
            puts "in header line: " + line
            if !inTagBlock
              if block.squish != ""
                puts "--------------------------------\n--------------------------------Block Stuff in text: " + block
                buckets.push block
                block = ""
                inTagBlock = true
              end
              inTagBlock = true
              block = block + "\r\n" + line  
            else
              block = block + "\r\n" + line
            end
          end
        end
      end

      block = block.strip
      if block != ""
        puts "--------------------------------\n--------------------------------Block Stuff in text: " + block
        buckets.push block
      end

      puts "--------------------------------All Buckets: " + buckets.join('Bucket: \n')
      return buckets
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
              tags.push tag.downcase
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
            line_items = Array.new
            line_items.push tempLine.squish
            
            line.scan(/#\S*/).each do |tag|
              line_items.push tag.downcase
            end
            items.push line_items
          end
        end
      end

      return items
    end

end
