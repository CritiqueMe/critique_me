#Rails::Engine.mixin __FILE__
class ShareController < ApplicationController
  def index
    @question = Question.find(params['question_id'])
    if request.post?
      get_contacts(params['email'], params['password'], params['provider'])
      if flash[:importer_error].nil?
        render :partial => "share/contacts"
      else
        render :text => "Failure: #{flash[:importer_error]}"
      end
    else
      get_fb_friends if @user.fb_user_id
      render :partial => "share/dialog"
    end
  end

  def manual_share
    if request.post?
      invitees = params['emails'].gsub(" ", '').split(",").collect{|x| {:email => x}}
      Invite.queue_invites(@user, invitees)
      if invitees.length >= 5
        render :partial => "share/thanks", :locals => {:num_shared => invitees.length}
      else
        render :partial => "share/oops"
      end
    end
  end

  def share_contacts
    # Create invite for each selected contact
    invitees = []
    imported_emails = params['imported_emails'].gsub(" ", "").split(",")
    imported_emails.each_with_index do |c, i|
      invitees << {:email => c, :fb_user_id => nil} if params["contact_#{i}"]
    end
    Invite.queue_invites(@user, invitees)
    if invitees.length >= 5
      render :partial => "share/thanks", :locals => {:num_shared => invitees.length}
    else
      render :partial => "share/oops"
    end
  end

  def share_friends
    @question = Question.find(params['question_id'])
    url = "https://graph.facebook.com/#{@user.fb_user_id}/feed"
    qtext = @question.question_text
    response = `curl -s -F 'access_token=#{session[:fb_access_token]}' -F 'message=#{qtext}' -F 'link=#{question_url(@question, :cmfb => 1)}' #{"-F 'picture=#{@question.photo.thumb.url}'" if @question.photo.url} -F 'name=Critique Me' -F 'caption=Ask Your Friends Anything!' -F 'description=#{@user.first_name.capitalize} asked "#{qtext}"' '#{url}'`
    Rails.logger.info "aaaa #{response}"
    # TODO: track this posting!
    render :partial => "share/thanks", :locals => {:num_shared => params['imported_friends'].split(",").length}
  end

  private

  def get_fb_friends
    if Rails.env.development?
      @fb_friends = dev_friends
    else
      url = "https://graph.facebook.com/me/friends?access_token=#{session[:fb_access_token]}"
      response = `curl -s '#{url}'`
      json = JSON.parse(response)
      if json['error']
        @fb_friends_error = json['error']['message']
      else
        @fb_friends = json['data'].sort{|a,b| a['name'] <=> b['name']}
      end
    end
  end


  # Stubbing in some FB functionality on dev
  def dev_friends
    [{"name"=>"Aaron Jistel", "id"=>"1507876957"}, {"name"=>"Adam Ward", "id"=>"148000172"}, {"name"=>"Al Evans", "id"=>"1444250800"}, {"name"=>"Alex Chen", "id"=>"7900501"}, {"name"=>"Alicia 'Moore' Whitley", "id"=>"508258962"}, {"name"=>"Alison Sarchet James", "id"=>"1603223499"}, {"name"=>"Allison Geggatt", "id"=>"100000843052571"}, {"name"=>"Allison McLarty Domonoske", "id"=>"1056562812"}, {"name"=>"Allison Singleton", "id"=>"100000046053192"}, {"name"=>"Allisyn Ayers Decatur", "id"=>"1495024657"}, {"name"=>"Allyson Jane Hamlin", "id"=>"25401775"}, {"name"=>"Alyssa Chien Grade", "id"=>"9201326"}, {"name"=>"Amy Dildine", "id"=>"11278"}, {"name"=>"Andrea Saenz", "id"=>"510616503"}, {"name"=>"Andrew Landau", "id"=>"644933962"}, {"name"=>"Anna Trotzuk Temple", "id"=>"100000126387994"}, {"name"=>"Antonio Zuniga", "id"=>"667287321"}, {"name"=>"April Johansen", "id"=>"1365004053"}, {"name"=>"Aron Branam", "id"=>"100000273422917"}, {"name"=>"Ashlee Morris Beeman", "id"=>"16702275"}, {"name"=>"Ashley Barnhill", "id"=>"7933822"}, {"name"=>"Audrey W Skelton", "id"=>"16716334"}, {"name"=>"Beau Aucoin", "id"=>"1169847282"}, {"name"=>"Becky Geggatt", "id"=>"1233450043"}, {"name"=>"Ben Ashley", "id"=>"1540399079"}, {"name"=>"Ben Irving", "id"=>"501406553"}, {"name"=>"Beth Von Brecht", "id"=>"8347159"}, {"name"=>"Blake Horton", "id"=>"7948747"}, {"name"=>"Bobby Hoover", "id"=>"2802120"}, {"name"=>"Brad Bourgeois", "id"=>"23410122"}, {"name"=>"Brad Levy", "id"=>"7923924"}, {"name"=>"Brandon Kuehler", "id"=>"16720682"}, {"name"=>"Brent Holubec", "id"=>"38708033"}, {"name"=>"Brent McPherson", "id"=>"100000994000477"}, {"name"=>"Brett Appolito", "id"=>"1229201399"}, {"name"=>"Brett Austin Jackson", "id"=>"511897127"}, {"name"=>"Brian Holsinger", "id"=>"16712759"}, {"name"=>"Brittany Kruger", "id"=>"8315242"}, {"name"=>"Brooke Parker-Canada", "id"=>"660910506"}, {"name"=>"Cali Leopold", "id"=>"1541970035"}, {"name"=>"Cameron Griffin", "id"=>"6511503"}, {"name"=>"Carly Rourke Brophy", "id"=>"7917396"}, {"name"=>"Caroline Ashby Burger", "id"=>"725648240"}, {"name"=>"Carter Williams", "id"=>"734766729"}, {"name"=>"Casey Boeer Clark", "id"=>"8315623"}, {"name"=>"Chad Fagan", "id"=>"66300289"}, {"name"=>"Charli Fuhler Sowrey", "id"=>"721903799"}, {"name"=>"Charlie Crawford", "id"=>"808857727"}, {"name"=>"Chris Ashman", "id"=>"100000436087698"}, {"name"=>"Chris Geggatt", "id"=>"18305426"}, {"name"=>"Chris Olson", "id"=>"7923135"}, {"name"=>"Chris Thomas", "id"=>"100001144757940"}, {"name"=>"Christopher Gaddis", "id"=>"9216266"}, {"name"=>"Christopher Ryan Welch", "id"=>"581916775"}, {"name"=>"Collin Evans", "id"=>"7929816"}, {"name"=>"Cory Gere", "id"=>"1205874941"}, {"name"=>"Courtney Devine Robertson", "id"=>"8329072"}, {"name"=>"Craig Corley", "id"=>"708179137"}, {"name"=>"Craig Gleaton", "id"=>"7928375"}, {"name"=>"Cristin Aylmer Steger", "id"=>"629948419"}, {"name"=>"Cynthia Gibbons", "id"=>"100000024267014"}, {"name"=>"Dalton Hale", "id"=>"7932582"}, {"name"=>"Dan Geggatt", "id"=>"1246230063"}, {"name"=>"Dana Dudek", "id"=>"644292550"}, {"name"=>"David Goodman", "id"=>"16707754"}, {"name"=>"David Hampton", "id"=>"7917903"}, {"name"=>"David Penney", "id"=>"7939438"}, {"name"=>"Dawn Ryden", "id"=>"25403736"}, {"name"=>"DeAnne Putman", "id"=>"1112613499"}, {"name"=>"Denise Wieners Geggatt", "id"=>"1196455181"}, {"name"=>"Derrick Hale", "id"=>"1018555414"}, {"name"=>"Destinee Smith", "id"=>"29607797"}, {"name"=>"Devon Winegar", "id"=>"7931561"}, {"name"=>"Don Rolleg", "id"=>"1184094632"}, {"name"=>"Donald Scheffler II", "id"=>"7926339"}, {"name"=>"Dookie McDeuce", "id"=>"100001488356101"}, {"name"=>"Dorothy Temple", "id"=>"100002285608407"}, {"name"=>"Dustin Duhon", "id"=>"1350379162"}, {"name"=>"Dusty Coleman", "id"=>"1309271950"}, {"name"=>"Elizabeth 'Moses' Caddell", "id"=>"7908024"}, {"name"=>"Elta Jerry Sarchet", "id"=>"1600870951"}, {"name"=>"Emily Evans", "id"=>"7914153"}, {"name"=>"Emily Neves Love", "id"=>"1365283030"}, {"name"=>"Eric Aldis", "id"=>"100000631340380"}, {"name"=>"Eric Long", "id"=>"7921704"}, {"name"=>"Erin Gleaton", "id"=>"622135118"}, {"name"=>"Erin Waits Blackwell", "id"=>"7946291"}, {"name"=>"Fred Sarchet", "id"=>"100002238654893"}, {"name"=>"George Temple Jr.", "id"=>"719950863"}, {"name"=>"Gerardo Churion", "id"=>"8373933"}, {"name"=>"Ginny Temple Geggatt", "id"=>"1009865492"}, {"name"=>"Glenn Eller", "id"=>"710796779"}, {"name"=>"Graylin D. Murray Jr.", "id"=>"1643599649"}, {"name"=>"Greg Burger", "id"=>"7946087"}, {"name"=>"Heather Antoinette Robbins", "id"=>"100000142166777"}, {"name"=>"Jaclyn Krossman Solomon", "id"=>"8338097"}, {"name"=>"Jake Decker", "id"=>"68202171"}, {"name"=>"James Spooner", "id"=>"623588603"}, {"name"=>"James Wesley", "id"=>"1359773761"}, {"name"=>"Janet Whisenhunt", "id"=>"1078364733"}, {"name"=>"Jared Wayne Wiatrek", "id"=>"8328388"}, {"name"=>"Jason Eyler", "id"=>"100001631412204"}, {"name"=>"Jason Marquardt", "id"=>"7930332"}, {"name"=>"Jason McClure", "id"=>"1598995827"}, {"name"=>"Jeana Gobar", "id"=>"100000108661447"}, {"name"=>"Jeff Hiddemen", "id"=>"7918084"}, {"name"=>"Jeff Marquardt", "id"=>"1556228243"}, {"name"=>"Jenny Turner", "id"=>"18304262"}, {"name"=>"Jeremiah Kraft", "id"=>"7911282"}, {"name"=>"Jeremy Shroder", "id"=>"25304909"}, {"name"=>"Jessica 'Youssef' Johnson", "id"=>"9208370"}, {"name"=>"Jessica Parks Richmond", "id"=>"29607155"}, {"name"=>"Jessica Pierce", "id"=>"7905156"}, {"name"=>"Jessie Boyer Amate", "id"=>"1093208499"}, {"name"=>"Jill Estep", "id"=>"8364975"}, {"name"=>"Jim Tucker", "id"=>"769948569"}, {"name"=>"Jimmy Ho", "id"=>"7906965"}, {"name"=>"John Belsha", "id"=>"24901464"}, {"name"=>"John Robert Thomas", "id"=>"557630383"}, {"name"=>"Jonathan Altman", "id"=>"8320890"}, {"name"=>"Jonathan Ellicott", "id"=>"4905826"}, {"name"=>"Jonathan Pelayo", "id"=>"7916743"}, {"name"=>"Jonathan York", "id"=>"1460630115"}, {"name"=>"Josh Huber", "id"=>"2316676"}, {"name"=>"Josh Max", "id"=>"100001784146340"}, {"name"=>"Juan Carlos Pulido", "id"=>"620441842"}, {"name"=>"Karri Scott", "id"=>"505990148"}, {"name"=>"Katie Bryan", "id"=>"24902668"}, {"name"=>"Katie Sarchet James", "id"=>"100000053886027"}, {"name"=>"Katrina Cohen Pound", "id"=>"29608101"}, {"name"=>"Keith Adkins", "id"=>"1535817665"}, {"name"=>"Kelli Hearn", "id"=>"183001288"}, {"name"=>"Kenny Liao", "id"=>"7901234"}, {"name"=>"Keri Tatum", "id"=>"183001316"}, {"name"=>"Kori Scott", "id"=>"620688119"}, {"name"=>"Kristen Greenwade Williams", "id"=>"7918817"}, {"name"=>"Kristof Kristofer", "id"=>"1699223828"}, {"name"=>"Krystal Sarchet-Fagan", "id"=>"1118762789"}, {"name"=>"Kyle Pfister", "id"=>"7911828"}, {"name"=>"Lacey 'Myers' Dahse", "id"=>"654686153"}, {"name"=>"Lacey 'Polniak' Kuehn", "id"=>"25416082"}, {"name"=>"Laura Spaulding", "id"=>"1300629411"}, {"name"=>"Laura Wang", "id"=>"501595403"}, {"name"=>"Lauren Kuen", "id"=>"586951767"}, {"name"=>"Lauren Skalka", "id"=>"7916602"}, {"name"=>"Leslie Bayless", "id"=>"1565516644"}, {"name"=>"Leslie Green Pitts", "id"=>"9209252"}, {"name"=>"Lindsay East", "id"=>"7915720"}, {"name"=>"Lindsay Farkash", "id"=>"843490477"}, {"name"=>"Liz Marquardt", "id"=>"7018565"}, {"name"=>"Lyndsey Thornett Zielinski", "id"=>"7927101"}, {"name"=>"Lynley Prather", "id"=>"7915288"}, {"name"=>"Madison Corley", "id"=>"100003329376596"}, {"name"=>"Mandy Patterson", "id"=>"1652317910"}, {"name"=>"Marcie Jones", "id"=>"100000156466321"}, {"name"=>"Marian Temple Corley", "id"=>"1560413758"}, {"name"=>"Marianne Hudson Horton", "id"=>"8332106"}, {"name"=>"Marjan Yazdan", "id"=>"7915516"}, {"name"=>"Marshall Fagan", "id"=>"100001554456852"}, {"name"=>"Mason Kelley", "id"=>"514278945"}, {"name"=>"Matt Park", "id"=>"100000559751127"}, {"name"=>"Matt Shaw", "id"=>"7910273"}, {"name"=>"Matt Stone", "id"=>"539215289"}, {"name"=>"Max Goldman", "id"=>"727384552"}, {"name"=>"Meagan 'Burke' Tatum", "id"=>"586340794"}, {"name"=>"Megan 'Hrncir' Pittenger", "id"=>"9217088"}, {"name"=>"Meggie Truelock", "id"=>"8334711"}, {"name"=>"Meghan 'Fluker' Rieber", "id"=>"7945341"}, {"name"=>"Meghan Passmore", "id"=>"29604469"}, {"name"=>"Melissa Fuller Spillman", "id"=>"7924142"}, {"name"=>"Melissa Pruet", "id"=>"23418757"}, {"name"=>"Melissa Smolensky", "id"=>"609616237"}, {"name"=>"Meredith Putt Edwards", "id"=>"1011732696"}, {"name"=>"Meredith Tallerine", "id"=>"7917177"}, {"name"=>"Meredith Weber Rankin", "id"=>"557738244"}, {"name"=>"Michael Burke", "id"=>"1262417474"}, {"name"=>"Michael McCullen", "id"=>"1166455288"}, {"name"=>"Michael Seery", "id"=>"16713494"}, {"name"=>"Michael Serf Sefara", "id"=>"29602817"}, {"name"=>"Michelle Kolpin Bruce", "id"=>"7911693"}, {"name"=>"Mike Guerrero", "id"=>"29619153"}, {"name"=>"Mikki Scully", "id"=>"1635095777"}, {"name"=>"Mr. President David J. Schlink", "id"=>"12702250"}, {"name"=>"Natalie Hiddemen", "id"=>"7915816"}, {"name"=>"Nathaniel Jones", "id"=>"683970773"}, {"name"=>"Nestor Martinez", "id"=>"735735882"}, {"name"=>"Nicholas Day", "id"=>"556215022"}, {"name"=>"Nicole Reding Holmes", "id"=>"1392884381"}, {"name"=>"Page 'Osburn' SoRell", "id"=>"29621309"}, {"name"=>"Patrick Rogers", "id"=>"26503090"}, {"name"=>"Paul B. Olson", "id"=>"1757889278"}, {"name"=>"Pete Rowley", "id"=>"1196913269"}, {"name"=>"Phillip Aurentz", "id"=>"7920510"}, {"name"=>"Phillip Domingue", "id"=>"1499853856"}, {"name"=>"Phillip Goldenburg", "id"=>"1512532485"}, {"name"=>"Price Pritchard", "id"=>"1267924717"}, {"name"=>"Rachel Langberg", "id"=>"7928221"}, {"name"=>"Rafael Henriques Dourado Teixeira", "id"=>"590865789"}, {"name"=>"Ramsay D. Zaki", "id"=>"9204346"}, {"name"=>"Raychelle Geggatt", "id"=>"7915721"}, {"name"=>"Raymond Horner", "id"=>"100000721004151"}, {"name"=>"Ricky Gardner", "id"=>"1552357991"}, {"name"=>"Rob Gandy", "id"=>"1404545712"}, {"name"=>"Robert Banta", "id"=>"100001434753696"}, {"name"=>"Rosina Ayala", "id"=>"57800093"}, {"name"=>"Ross Pittenger", "id"=>"513434572"}, {"name"=>"Russell Lemmer", "id"=>"7937072"}, {"name"=>"Russell Smith", "id"=>"100001425513509"}, {"name"=>"Ryan Bickley", "id"=>"1405704083"}, {"name"=>"Ryan Kitson", "id"=>"1198681942"}, {"name"=>"Ryan Koonce", "id"=>"100000999366587"}, {"name"=>"Ryan Koonce", "id"=>"2328993"}, {"name"=>"Ryan Moore", "id"=>"16713381"}, {"name"=>"Ryan O'Quinn", "id"=>"23404969"}, {"name"=>"Ryan William Wallace", "id"=>"7927326"}, {"name"=>"Samantha Temple Anderson", "id"=>"1067346150"}, {"name"=>"Samuel Morris", "id"=>"1428939205"}, {"name"=>"Sara Krauser", "id"=>"1772776473"}, {"name"=>"Sarah Griffin Covey", "id"=>"1517809628"}, {"name"=>"Sarah Todd", "id"=>"29612910"}, {"name"=>"Sean Brown", "id"=>"13916345"}, {"name"=>"Sebastian Burfitt", "id"=>"1245756661"}, {"name"=>"Sergio Marazita", "id"=>"37520827"}, {"name"=>"Shandy Sarchet", "id"=>"1246917630"}, {"name"=>"Shea Lauren Kummer", "id"=>"18305098"}, {"name"=>"Shelley Osborn Pfister", "id"=>"1110474113"}, {"name"=>"Sonja Hearn", "id"=>"530599200"}, {"name"=>"Spencer Nilsson", "id"=>"888125612"}, {"name"=>"Stacie Jones Long", "id"=>"1830890730"}, {"name"=>"Stacie Stepp Lalendorff", "id"=>"1579811099"}, {"name"=>"Stephanie Escamilla", "id"=>"7923398"}, {"name"=>"Stephanie Redding Hardie", "id"=>"628163615"}, {"name"=>"Sterling Leopold", "id"=>"1409726419"}, {"name"=>"Steve Boyd", "id"=>"506251287"}, {"name"=>"Steve Lombardi", "id"=>"18302216"}, {"name"=>"Susanna Hackleman", "id"=>"702961645"}, {"name"=>"Susie Sarchet", "id"=>"1327823511"}, {"name"=>"T.J.  Berry", "id"=>"7910871"}, {"name"=>"Tatiana Canales Penney", "id"=>"7930462"}, {"name"=>"Teresa Lowther Mason", "id"=>"500206357"}, {"name"=>"Teresa Salvaggio Russell", "id"=>"1266178382"}, {"name"=>"Tiffany Christman", "id"=>"64200157"}, {"name"=>"Tina Sy", "id"=>"7918368"}, {"name"=>"Todd McKeehan", "id"=>"16717660"}, {"name"=>"Todd Pfister", "id"=>"500333643"}, {"name"=>"Todd Wesley", "id"=>"1549040588"}, {"name"=>"Tom Geggatt", "id"=>"1096747554"}, {"name"=>"Tony Oyeneyin", "id"=>"100001015890674"}, {"name"=>"Travis Holloway", "id"=>"7923830"}, {"name"=>"Travis Roby", "id"=>"756168696"}, {"name"=>"Travis Wright", "id"=>"1147243228"}, {"name"=>"Tricia Kruger Gittemeier", "id"=>"7923452"}, {"name"=>"Vanessa Carpenter", "id"=>"14700872"}, {"name"=>"Vijay Dixit", "id"=>"7910803"}, {"name"=>"Viresh Patel", "id"=>"7925259"}, {"name"=>"Winton Welsh", "id"=>"23918049"}, {"name"=>"Zach Lucky", "id"=>"1548124798"}, {"name"=>"Zachary Zotter", "id"=>"16727808"}, {"name"=>"Zack McKamie", "id"=>"7953159"}]
  end
end