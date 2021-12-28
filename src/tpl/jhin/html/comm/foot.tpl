{if !$base}
	<hr>
	<div class="breadcrumb">
		<p>
			{date("n月j日 H:i")} 星期{call_user_func_array("str::星期",array(date("w")))}
		</p>
		<p>
			效率: {round(microtime(true)-$smarty.server.REQUEST_TIME_FLOAT,3)}秒<!--(压缩:{if $page.gzip}开{else}关{/if})-->
		</p>
		<p>
			[<a href="index.index.{$BID}">首页</a>]
			[<a href="#top">回顶</a>]
		</p>
		<p>
			本站由 <a href="https://gitee.com/hu60t/hu60wap6">hu60wap6</a> 驱动
		</p>
		<p>
			{#SITE_RECORD_NUMBER#}
		</p>
		{if !$no_chat}
			{$chat=chat::getInstance($USER)}
			{if is_object($USER) && $USER->getinfo('chat.newchat_num') > 0}
				{$newChatNum=$USER->getinfo('chat.newchat_num')}
			{else}
				{$newChatNum=1}
			{/if}
			{$newChats=$chat->newChats($newChatNum)}
			{if !empty($newChats)}
				{$ubb=ubbDisplay::getInstance()}
				<div class="chat-new content-box">
				{foreach $newChats as $newChat}
					{$content=strip_tags($ubb->display($newChat.content, true))}
					<p class="user-content">[<a href="addin.chat.{$newChat.room|code}.{$BID}">聊天-{$newChat.room|code}</a>] {$newChat.uname|code}：{str::cut($content,0,50,'…')}</p>
				{/foreach}
				</div>
			{/if}
		{/if}
	</div>
{/if}
<script src="{$PAGE->getTplUrl("js/hu60/footer.js", true)|code}"></script>
</body>
</html>
