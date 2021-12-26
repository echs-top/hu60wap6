{config_load file="conf:site.info"}
{if $fid == 0}
	{$fName=#BBS_INDEX_NAME#}
	{$title=#BBS_NAME#}
{else}
	{$fIndex.0.name=#BBS_INDEX_NAME#}
	{$title="{$fName} - {#BBS_NAME#}"}
{/if}
{include file="tpl:comm.head" title=$title}

<!--导航栏-->
<div class="tp">
	<a  href="index.index.{$bid}">首页</a> &gt;
	{$size=count($fIndex)-1}
	{foreach $fIndex as $i=>$forum}
		{if $i<$size}
			<a href="{$CID}.forum.{$forum.id}.{$BID}">{$forum.name|code}</a> &gt;
		{/if}
	{/foreach}
	{if $fid == 0}
		<a href="{$CID}.forum.{$fid}.{$BID}">{$fName}</a>
	{else}
		{$fName}
	{/if}

	(<a href="{$CID}.newtopic.{(int)$forum.id}.{$BID}">发帖</a>)

	{if $forumInfo}
			&gt;
			<select id="forum" onchange="location='{$CID}.{$PID}.'+this.options[this.selectedIndex].value+'.{$BID}'">
				<option value="0">进入子版块</option>
				{foreach $forumInfo as $forum}
					<option value="{$forum.id}">{$forum.name|code}</option>
				{/foreach}
			</select>
	{/if}
	<input
		type="checkbox"
		id="only_essence"
		{if $onlyEssence}checked{/if}
		onchange="location='{$CID}.{$PID}.{$fid}.1.' + (this.checked ? 1 : 0) + '.{$BID}'"
	/><label for="only_essence">只看精华</label>
</div>


<!--帖子列表-->
<hr>
<div>
	<ol style="padding-left:2em">
		{foreach $topicList as $topic}
			<li>
				{if $topic.essence}<span style="color:red;">[精]</span>{/if}
				<a class="user-title" href="{$CID}.topic.{$topic.topic_id}.{$BID}">{$topic.title|code}</a>
				{if $topic.review}
					<div class="topic-status">{bbs::getReviewStatName($topic.review)}</div>
				{/if}
				{if $topic.uinfo->hasPermission(UserInfo::DEBUFF_BLOCK_POST)}
					<div class="topic-status">被禁言</div>
				{/if}
				{if $topic.locked == 2}
					<div class="topic-status">评论关闭</div>
				{elseif $topic.locked}
					<div class="topic-status">被锁定</div>
				{/if}
                {if $topic.level < 0}
                    <div class="topic-status">被下沉</div>
                {/if}
				<br>
				({$topic.uinfo.name|code} / {$topic.read_count}点击 / {$topic.reply_count}回复 / {str::ago($topic.ctime)}发布 / {str::ago($topic.mtime)}回复)
			</li>
		{/foreach}
	</ol>
	<hr>
	<p class="tp">
		{if $p < $pMax}<a href="{$CID}.{$PID}.{$fid}.{$p+1}.{intval($onlyEssence)}.{$BID}">下一页</a>{/if}
		{if $p > 1}<a href="{$CID}.{$PID}.{$fid}.{$p-1}.{intval($onlyEssence)}.{$BID}">上一页</a>{/if}
		{$p}/{$pMax}页,共{$topicCount}条
		<input placeholder="跳页" id="page" size="2" onkeypress="if(event.keyCode==13){ location='{$CID}.{$PID}.{$fid}.'+this.value+'.{intval($onlyEssence)}.{$BID}'; }">
	</p>
</div>

{include file="tpl:comm.foot"}
