base_url = "http://#{request.host_with_port}"
xml.instruct! :xml, :version=>'1.0'
xml.tag! 'urlset', 'xmlns' => 'http://www.sitemaps.org/schemas/sitemap/0.9' do
  xml.url{
      xml.loc("http://www.gabblin.com")
      xml.changefreq("daily")
      xml.priority(1.0)
  }

  xml.url{
      xml.loc("http://www.gabblin.com/signin")
      xml.changefreq("daily")
      xml.priority(0.9)
  }


  xml.url{
      xml.loc("http://www.gabblin.com/join")
      xml.changefreq("daily")
      xml.priority(0.9)
  }

  xml.url{
      xml.loc("http://www.gabblin.com/encyclopedia/vision")
      xml.changefreq("weekly")
      xml.priority(0.8)
  }
  xml.url{
      xml.loc("http://www.gabblin.com/encyclopedia/contact")
      xml.changefreq("weekly")
      xml.priority(0.8)
  }
  
  xml.url{
      xml.loc("http://www.gabblin.com/encyclopedia/careers")
      xml.changefreq("weekly")
      xml.priority(0.8)
  } 


  xml.url{
      xml.loc("http://www.gabblin.com/encyclopedia/rules")
      xml.changefreq("weekly")
      xml.priority(0.8)
  } 

  @posts.each do |post|
    xml.url {
      xml.loc "#{community_post_url(post.community, post)}"
      xml.lastmod post.updated_at.strftime("%F")
      xml.priority(0.6)
    }
  end
  
  @users.each do |user|
    xml.url {
      xml.loc "#{user_url(user)}"
      xml.lastmod user.updated_at.strftime("%F")
      xml.priority(0.5)
    }
  end

end