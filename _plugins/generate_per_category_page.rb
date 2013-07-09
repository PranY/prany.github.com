module Jekyll
 class TopicIndex < Page    
 
    def initialize(site, base, dir, category)
      @site = site
      @base = base
      @dir = dir
      @name = 'index.html'

      # get topic's posts
      category_posts = []
      site.posts.each do |p|
        ((category_posts << p) if p.categories.include? category) if p.categories
      end

      self.process(@name)
      self.read_yaml(File.join(base, '_layouts'), 'topic_index.html')
      self.data['posts'] = category_posts.reverse
      self.data['category'] = category 
      self.data['title'] = "Topic \""+category+"\""
    end
  end

  class TopicIndexGenerator < Generator
    safe true
    
    def generate(site)
      if site.layouts.key? 'topic_index'
        dir = 'category'
        
        # get list of the unique topics
        categories = [];
        site.posts.each do |p|
          p.categories.each do |t|
            categories << t if !categories.include? t
          end if p.categories
        end
        
        # create page for each topic
        categories.each do |topic|
          write_topic_index(site, File.join(dir, topic.downcase), topic)
        end
      end
    end
  
    def write_topic_index(site, dir, topic)
      index = TopicIndex.new(site, site.source, dir, topic)
      index.render(site.layouts, site.site_payload)
      index.write(site.dest)
      site.pages << index
    end
  end
end
