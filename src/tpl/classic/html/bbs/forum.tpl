{config_load file="conf:site.info"}
{if $fid == 0}
	{$fName=#BBS_INDEX_NAME#}
	{$title=#BBS_INDEX_NAME#}
{else}
	{$fIndex.0.name=#BBS_INDEX_NAME#}
	{$title="{$fName} - {#BBS_NAME#}"}
{/if}
{include file="tpl:comm.head" title=$title}

<!--导航栏-->
<div class="tp">
	<a  href="index.index.{$bid}">首页</a> &gt;
	{$fName}
	(<a href="{$CID}.{$PID}.0.1.{$BID}">新帖</a> |
	<a href="{$CID}.{$PID}.0.1.1.{$BID}">精华</a> |
	<a href="{$CID}.newtopic.0.{$BID}">发帖</a>{if $countReview}
	| <a href="{$CID}.search.{$BID}?onlyReview=1">{$countReview}待审核</a>{/if})
</div>

<!--搜索框-->
<div class="tp">
	<form method="get" action="{$CID}.search.{$BID}">
		<input name="keywords" placeholder="搜索词" />
		<input name="username" placeholder="用户名" />
		<input type="submit" value="搜索" />
	</form>
</div>
<hr>
<!--版块列表-->
<div>
{foreach $forumInfo as $forum name="forum"}
	<div>
		<div class="tp">&gt;{$forum.name|code}(<a href="bbs.forum.{$forum['id']}.{$BID}" >新帖/发帖</a>)</div>
		<ol style="padding-left:1.5em">
		{foreach $forum.newTopic as $topic}
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
				{if $USER->canAccess(1) && $topic.access == 0}
					<div class="topic-status">公开</div>
				{/if}
			</li>
		{/foreach}
		</ol>
	</div>
	{if !$smarty.foreach.forum.last}<hr>{/if}
{/foreach}
	
{include file="tpl:comm.foot"}
