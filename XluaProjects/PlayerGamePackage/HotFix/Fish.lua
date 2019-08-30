local UnityEngine=CS.UnityEngine
--1.1

--1.点击宝箱领取的金币钻石太拥挤，分散一点。
xlua.hotfix(CS.Treasour,'CreatePrize',function(self)
   for i=0,4,1 do
	  local go=UnityEngine.GameObject.Instantiate(self.gold,self.transform.position+UnityEngine.Vector3(-10+i*60,0,0),self.transform.rotation);
	   go.transform.SetParent(go.transform,self.cavas);
	   local go1=UnityEngine.GameObject.Instantiate(self.diamands,self.transform.position+UnityEngine.Vector3(0,60,0)+UnityEngine.Vector3(-10 + i * 60, 0, 0),self.transform.rotation);
	   go.transform.SetParent(go1.transform,self.cavas);
   end
end
)

xlua.private_accessible(CS.Gun) --访问私有函数
--2.玩家金币钻石不够时没有相应处理。
xlua.hotfix(CS.Gun,'Attack',function(self)
     if UnityEngine.Input.GetMouseButtonDown(0) then  --静态函数不需要self

			if self.gold<1+(self.gunLevel-1)*2 or gold==0 then
			   return
			end

			self.bullectAudio.clip=self.bullectAudios[self.gunLevel-1]
			self.bullectAudio:Play()
			if self.Butterfly then
			     UnityEngine.GameObject.Instantiate(self.Bullects[self.gunLevel-1],self.attackPos.position, self.attackPos.rotation * UnityEngine.Quaternion.Euler(0, 0, 20))
				UnityEngine.GameObject.Instantiate(self.Bullects[self.gunLevel-1],self.attackPos.position, self.attackPos.rotation * UnityEngine.Quaternion.Euler(0, 0, -20))
			end

			UnityEngine.GameObject.Instantiate(self.Bullects[self.gunLevel - 1], self.attackPos.position, self.attackPos.rotation);

			if not self.canShootForFree then
			     self:GoldChange(-1-(self.gunLevel-1)*2)
			end
			self.attackCD=0;
			self.attack = false;
	 end
end
)
