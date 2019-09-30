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

--******************************************************
xlua.private_accessible(CS.Gun) --访问私有函数
--2.玩家金币钻石不够时没有相应处理。
xlua.hotfix(CS.Gun,'Attack',function(self)
     if UnityEngine.Input.GetMouseButtonDown(0) then  --静态函数不需要self

	        --1.2与ui交互时不能发射子弹

			if UnityEngine.EventSystems.EventSystem.current:IsPointerOverGameObject() then --用于检查有ui是否被按下
				return
            end

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

--*******************************
--1.2技能扣掉的砖石太多了
xlua.private_accessible(CS.Fire)  --访问私有的方法
xlua.hotfix(CS.Fire,"Start",function(self)
       self.reduceDiamands=8;
end
)

xlua.private_accessible(CS.Ice)  --访问私有的方法
xlua.hotfix(CS.Ice,"Start",function(self)
       self.reduceDiamands=8;
end
)

xlua.private_accessible(CS.ButterFly)  --访问私有的方法
xlua.hotfix(CS.ButterFly,"Start",function(self)
       self.reduceDiamands=5;
end
)

--****************************************
local util=require "util"

xlua.private_accessible(CS.Boss)
util.hotfix_ex(CS.Boss,"Start",function(self)
     self.Start(self)   --先让其执行完原先start里面的内容
	 self.m_reduceGold = m_reduceGold-20; --然后执行我们新添加的代码
end)

xlua.private_accessible(CS.DeffendBoss)
util.hotfix_ex(CS.DeffendBoss,"Start",function(self)
     self.Start(self)   --先让其执行完原先start里面的内容
	 self.m_reduceGold = -30; --然后执行我们新添加的代码
end)

xlua.private_accessible(CS.InvisibleBoss)
util.hotfix_ex(CS.InvisibleBoss,"Start",function(self)
     self.Start(self)   --先让其执行完原先start里面的内容
	 --self.m_reduceDiamond=m_reduceDiamond-5 --鳄鱼扣的是砖石

end)

--***************
--1.3

--1.boss撞击玩家当钻石金币不够时会产生负数。
util.hotfix_ex(CS.Gun,"GoldChange",function(self,number)
       self.GoldChange(self,number)
	   if self.gold<-number then
	      self.gold=0;
	      return
	   end
end)

--2.炮台3太强，且钻石没用处，不削弱，只有氪金才可使用。
--3.大鱼太多。
