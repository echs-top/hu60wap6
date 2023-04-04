{extends file='tpl:comm.default'}
{block name='title'}
收信箱
{/block}
{block name='body'}
<div class="breadcrumb">
  发件箱：
  {if !in_array($PAGE.ext[1],['yes','no'])}全部{else}<a href="msg.index.outbox.all.{$bid}">全部</a>{/if}&nbsp;
  {if $PAGE.ext[1] == 'no'}对方未读{else}<a href="msg.index.outbox.no.{$bid}">对方未读</a>{/if}&nbsp;
  {if $PAGE.ext[1] == 'yes'}对方已读{else}<a href="msg.index.outbox.yes.{$bid}">对方已读</a>{/if}&nbsp;
  <a href="msg.index.send.{$bid}">发信</a>
</div>
{if !empty($list)}
{foreach $list as $k}
{$tmp=$uinfo->uid($k.touid)}
<div class="msg_box">
  <p>{if $k.isread==0}[对方未读] {/if}发给：<a href="msg.index.chat.{$k.touid}.{$bid}">{$uinfo.name}</a></p>
  <p class="user-content">内容：<a href="msg.index.view.{$k.id}.{$bid}">{str::cut(html_entity_decode(strip_tags($ubbs->display($k.content,true))),0,100,'...', 'utf-8', true)|code}</a></p>
  <p>时间：{date("Y-m-d H:i:s",$k.ctime)}</p>
</div>
<hr />
{/foreach}
    <div class="widget-page">
        {jhinfunc::Pager($p,$pMax,"?p=##")}
    </div>
{else}
发件箱里空空的。
{/if}
<div class="breadcrumb">
  <a href="msg.index.inbox.all.{$bid}">收件箱</a> |
  发件箱 |
  <a href="msg.index.@.{$bid}">@消息</a> |
  <a href="user.wechat.{$bid}">微信推送</a>: {$wechat = $USER->getinfo('wechat')}{if $wechat.uid}开{else}关{/if}
</div>
{/block}
