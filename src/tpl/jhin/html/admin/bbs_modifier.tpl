<div class='title'>修改板块信息</div>
{if $smarty.post.yes}
    <div class='msg'>修改成功!</div>
{/if}
<form action="admin.bbs.bk.{$bid}" method="post">
    <input type="hidden" name="xg" value="我要修改你">
    <input type="hidden" name="parent_id" value="{$smarty.post.bbid}">
    <div class="field">
        <label class="label">版块名称</label>
        <div class="control">
            <input class="input" type="text" name="name" value="{$xg['name']}">
        </div>
    </div>
    <div class="field">
        <label class="label">父版块</label>
        <div class="control">
            <div class="select">
                <select name="parent_id">
                    {foreach $forumList as $v}
                        <option value="{$v.id}">{$v.title}</option>
                    {/foreach}
                </select>
            </div>
        </div>
    </div>
    <div class="field">
        <div class="control">
            <input type="submit" name="yes" id="submit" class="button" value="修改"/>
        </div>
    </div>
</form>