function _init()

	cls(0)
	
	startscreen()
	
	blinkt=1
	
	t=0
	
end

function _update()
	t+=1
	blinkt+=1

	if mode=="game" then
		update_game()
	elseif mode=="start" then
		update_start()
	elseif mode=="wavetext" then
		update_wavetext()
	elseif mode=="over" then
		update_over()
	elseif mode=="win" then
		update_win()
	end
	
end


function _draw()

	if mode=="game" then
		draw_game()
	elseif mode=="start" then
		draw_start()
	elseif mode=="wavetext" then
		draw_wavetext()
	elseif mode=="over" then
		draw_over()
	elseif mode=="win" then
		draw_win()
	end
	
end

function startscreen()
	mode="start"
	music(0)
end

function start_game()
	music(-1,1000)
	t=0
	
	wave=0
	nextwave()
	
	ship={}

	
	ship.x=64
	ship.y=64
	ship.sx=0
	ship.sy=0
	ship.spr=2
	
	lifespr=2
	dthspr=11
	
	tdspr=13
	tdfspr=14
	
	blatimer=0
	
	muzzle=0
	
	score=0
	
	lives=3
	invul=0
	
	tornum=3
	
	stars={}
	
	for i=1,100 do
		local newstar={}
		newstar.x=flr(rnd(128))
		newstar.y=flr(rnd(128))
		newstar.spd=rnd(1.5)+0.5
		add(stars,newstar)
	end
	
	blabs={}
	
	tors={}
	
	enemies={}
	
	explos={}
	
	parts={}
	
end

--tab 1

--helpers

function starfield()
	
	for i=1,#stars do
		local mystar=stars[i]
		local scol=6
		
		if mystar.spd<1 then
			scol=1
		elseif mystar.spd<1.5 then
			scol=13
		end
		
		pset(mystar.x,mystar.y,scol)
	end
	
end	

function animatestars()
	
	for i=1,#stars do
		local mystar=stars[i]
		mystar.y=mystar.y+mystar.spd
	
		if mystar.y>128 then
		mystar.y=mystar.y-128
		end
	end
	
end

function blink()

	local banim={5,5,6,6,7,7,6,6,5}
	if blinkt>#banim then
		blinkt=1
	end
	
	return banim[blinkt]
	
end

function drwmyspr(myspr)
	spr(myspr.spr,myspr.x,myspr.y)
end

function col(a,b)

	local a_left=a.x
	local a_top=a.y
	local a_right=a.x+7
	local a_btm=a.y+7
	
	local b_left=b.x
	local b_top=b.y
	local b_right=b.x+7
	local b_btm=b.y+7
	
	if a_top>b_btm then
		return false
	end
	if b_top>a_btm then
		return false
	end
	if a_left>b_right then
		return false
	end
	if b_left>b_right then
		return false
	end
	
	return true
	
end

function spawnen()

	local myen={}
	myen.x=rnd(120)
	myen.y=-8
	myen.spr=5
	myen.hp=5
	myen.flash=0
	
	add(enemies,myen)
	
end

function explode(expx,expy,isblue)
	
	local myp={}
	myp.x=expx
	myp.y=expy
	
	myp.sx=0
	myp.sy=0
	
	myp.age=0
	myp.size=8
	myp.maxage=0
	myp.blue=isblue
	
	add(parts,myp)
	
	for i=1,30 do
		local myp={}
		myp.x=expx
		myp.y=expy
		
		myp.sx=(rnd()-0.5)*8
		myp.sy=(rnd()-0.5)*8
		
		myp.age=rnd(5)
		myp.size=1+rnd(4)
		myp.maxage=10+rnd(10)
		myp.blue=isblue
		
		add(parts,myp)
	end
	
end

function page_red(page)
		
		local myspr=64
		
		if page>5 then
			myspr+=2
		end
		if page>7 then
			myspr+=2
		end
		if page>10 then
			myspr+=2
		end
		if page>12 then
			myspr+=2
		end
		if page>15 then
			myspr+=2
		end
	
		return myspr
		
	end
	
	function page_blue(page)
		
		local myspr=96
		
		if page>5 then
			myspr+=2
		end
		if page>7 then
			myspr+=2
		end
		if page>10 then
			myspr+=2
		end
		if page>12 then
			myspr+=2
		end
		if page>15 then
			myspr+=2
		end
	
		return myspr
		
	end

--tab 2

--update

function update_game()
	
	ship.sx=0
	ship.sy=0
	ship.spr=2

	--controls
	if btn(0) then
		ship.sx=-2
		ship.spr=1
	elseif btn(1) then
		ship.sx=2
		ship.spr=3
	elseif btn(2) then
		ship.sy=-2
	elseif btn(3) then
		ship.sy=2
	end
	
	if btn(5) then
		if blatimer<=0 then
			local newblab={}
			newblab.x=ship.x
			newblab.y=ship.y-3
			newblab.spr=17
			add(blabs,newblab)
			
			sfx(0)
			muzzle=5
			blatimer=4
		end
	end
	blatimer-=1
	
	if btnp(4) and tornum>=1 then
		local newtor={}
		
		newtor.x=ship.x
		newtor.y=ship.y-3
		newtor.spr=38
		
		add(tors,newtor)
	
		sfx(1)
		muzzle=5
		tornum-=1
	end
	
	--moving the ship
	ship.x+=ship.sx
	ship.y+=ship.sy
	
	--checking if ship hits edge
	if ship.x>120 then
		ship.x=0
	elseif ship.x<0 then
		ship.x=120
	end
	if ship.y<0 then
		ship.y=0
	end
	if ship.y>120 then
		ship.y=120
	end
	
	--moving blaster bolts
	for i=#blabs,1,-1 do
		local myblab=blabs[i]
		myblab.y=myblab.y-8
		
		if myblab.y<-8 then
			del(blabs,myblab)
		end
	end
	
	--moving + animating torpedoes
	for i=#tors,1,-1 do
		local mytor=tors[i]
		mytor.y=mytor.y-4
		
		mytor.spr+=1
	
		if mytor.spr>44 then
			mytor.spr=38
		end
		
		if mytor.y<-8 then
			del(tors,mytor)
		end
	end
	
	--moving enemies
	for myen in all(enemies) do
		myen.y+=1
		
		myen.spr+=0.2
		if myen.spr>=9 then
			myen.spr=5
		end
		
		if myen.y>128 then
			del(enemies,myen)
			spawnen()
		end
	end
	
	
	--collision blabs x enemies
	for myen in all(enemies) do
		for myblab in all(blabs) do
			if col(myen,myblab) then
				--draw + animate sparks
				myblab.spr+=1
				myblab.y+=10
				if myblab.spr>=19 then
					del(blabs,myblab)
				end
				
				myen.hp-=1
				sfx(4)
				myen.flash=2
				
				if myen.hp<=0 then
					del(enemies,myen)
					sfx(3)
					score+=1
					explode(myen.x-6,myen.y-6)
					
					if #enemies==0 then
						nextwave()
					end
					
				end
				
			end
		end
	end
	
	--collision tors x enemies
	for myen in all(enemies) do
		for mytor in all(tors) do
			if col(myen,mytor) then
				del(tors,mytor)
				myen.hp-=5
				sfx(4)
				myen.flash=30
				
				if myen.hp<=0 then
					del(enemies,myen)
					sfx(3)
					score+=1
					explode(myen.x-6,myen.y-6)
					
					if #enemies==0 then
						nextwave()
					end
					
				end
				
			end
		end
	end
	
	--collision ship x enemies
	if invul<=0 then
		for myen in all(enemies) do
			if col(myen,ship) then
				explode(ship.x-6,ship.y-6,true)
				lives-=1
				sfx(2)
				invul=60
			end
		end
	else
		invul-=1
	end
	
	if lives<=0 then
		mode="over"
		music(1)
		return
	end
	
	--animate muzzle flash
	
	if muzzle>0 then
		muzzle=muzzle-1
	end
	
	--animate stars
	animatestars()
		
end

function update_start()
	if btn(4)==false and btn(5)==false then
		btnreleased=true
	end
	
		if btnreleased then
		if btnp(4) or btnp(5) then
			start_game()
			btnreleased=false
		end
	end
end

function update_over()

	if btn(4)==false and btn(5)==false then
		btnreleased=true
	end
	
		if btnreleased then
		if btnp(4) or btnp(5) then
			startscreen()
			btnreleased=false
		end
	end
end

function update_win()
	if btn(4)==false and btn(5)==false then
		btnreleased=true
	end
	
	if btnreleased then
		if btnp(4) or btnp(5) then
			startscreen()
			btnreleased=false
		end
	end
end

function update_wavetext()
	update_game()
	wavetime-=1
	if wavetime<0 then
		mode="game"
		spawnwave()
	end
end

--tab 3

--draw

function draw_game()

	cls(0)
	starfield()
	if invul<=0 then
		drwmyspr(ship)
	else
		--invul state
		if sin(t/5)<0.1 then
			drwmyspr(ship)
		end
	end
	
	--drawing enemies
	for myen in all(enemies) do
		if myen.flash>0 then
			myen.flash-=1
			
			for i=1,15 do
				pal(i,7)
			end
			
		end
		drwmyspr(myen)
		pal()
	end

	--drawing blaster bolts
	for myblab in all(blabs) do
		drwmyspr(myblab)
	end
	
	--drawing shwaves
	--for mysw in all(shwaves) do
		--circ(mysw.x,mysw.y,mysw.r,mysw.col)
		--mysw.r+=mysw.speed
		--if mysw.r>mysw.tr then
			--del(shwaves,mysw)
		--end
	--end
	
	--drawing particles
	for myp in all(parts) do
		--local pc=7
		
		--if myp.age>5 then
			--pc=10
		--end
		--if myp.age>7 then
			--pc=9
		--end
		--if myp.age>10 then
			--pc=8
		--end
		--if myp.age>12 then
			--pc=2
		--end
		--if myp.age>15 then
			--pc=5
		--end
		
		local myspr=64
		
		if myp.blue then
			myspr=page_blue(myp.age)
		else
			myspr=page_red(myp.age)
		end
		
		--circfill(myp.x,myp.y,myp.size,pc)
		spr(myspr, myp.x, myp.y, 2, 2)
	
			
		myp.x+=myp.sx
		myp.y+=myp.sy
		
		myp.sx*=0.85
		myp.sy*=0.85
		
		myp.age+=1
		
		if myp.age>myp.maxage then
			myp.size-=0.5
			if myp.size<0 then
				del(parts,myp)
			end
		end
		
	end
	
	--drawing torpedoes
	for mytor in all(tors) do
		drwmyspr(mytor)
	end
	
	if muzzle>0 then
		circfill(ship.x+2,ship.y-1,muzzle,7)
		circfill(ship.x+5,ship.y-1,muzzle,7)
	end
	
	print("score:"..score,53,1,12)
	
	--lives display
	
	for i=1,3 do
		if lives>=i then
			spr(lifespr,i*9-8,1)
		else
			spr(dthspr,i*9-8,1)
		end		
	end
	
	--torpedoes display
	
	for i=1,3 do
		if tornum>=i then
			spr(tdspr,(i*9)+93,1)
		else
			spr(tdfspr,(i*9)+93,1)
		end
	end
	
end

function draw_start()

	cls(1)
	print("naboo starfighter",30,40,12)
	print("press any key to start",21,80,blink())

end

function draw_over()

	cls(8)
	print("game over",48,40,12)
	print("press any key to continue",19,80,7)
end

function draw_win()

	cls(11)
	print("congratulations!",36,40,12)
	print("press any key to continue",19,80,7)

end	

function draw_wavetext()
	draw_game()
	print("wave "..wave,56,40,blink())
end

--tab 4

--waves and enemies

function spawnwave()
	spawnen()
end

function nextwave()
	wave+=1
	
	if wave>4 then
		mode="win"
	else
		mode="wavetext"
		wavetime=60
	end
	
end