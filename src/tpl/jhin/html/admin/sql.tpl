{include file="tpl:comm.head" title="执行SQL" no_user=true}
<div class="tp"><a href="{$CID}.index.{$BID}">管理后台</a></div>
<div class='content'>
{form action="$CID.$PID.$BID" method="post"}
{if $showdbname}SQLite数据库名:{input name="dbname" value=$smarty.post.dbname}<br/>{/if}
SQL:{input type="textarea" name="sql" value=$sql size=array("45","5")}<br/>
{input type="submit" value="执行"}
{/form}
</div>
{if $ok !== null}
<div class='tip'>
{if $ok === true}
<span class="text-notice">SQL执行成功</span>
{foreach $db as $i => $arr}
<div class='{if $i%2}tip{else}content{/if}'>
{span style="color:#090;"}#{$i+1}</span><br/>
{foreach $arr as $n => $v}
<span class="text-notice">{$n|code}</span> {span style="color:#090;"}=</span> {$v|code:true}<br/>
{/foreach}
</div>
{/foreach}
{else}
<span class="text-notice">SQL执行失败</span><br/>
错误信息:<br/>
<span class="text-notice">{$msg[2]|code}</span>
{/if}
</div>
{/if}
{include file="tpl:comm.foot"}