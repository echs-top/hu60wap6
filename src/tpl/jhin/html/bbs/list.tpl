<ul class="topic-ul">
    {foreach $topicList as $topic}
        {if !isset($topic.topic_id) && isset($topic.id)}
            {$topic.topic_id = $topic.id}
        {/if}
        <li>
            <div class="topic-anchor">
                <a href="user.info.{$topic.uinfo.uid}.{$BID}">
                <img src="{$topic.uinfo->avatar()}" class="avatar">
                </a>
                <a href="user.info.{$topic.uinfo.uid}.{$BID}">{$topic.uinfo.name|code}</a>
            </div>
            <div class="topic-title">
                <a class="user-title" href="bbs.topic.{$topic.topic_id}.{$BID}">{if $topic.essence}<i class="material-icons" style="color:red;">whatshot</i>{/if}{$topic.title|code}</a>
                <div class="topic-meta">
                    {$topic.read_count}点击 / {str::ago($topic.ctime)}发布 / {str::ago($topic.mtime)}回复
                    {if $PID == 'myfavorite'}<input type="button" onclick="unsetFavoriteTopic({$topic.id}); return false" value="取消收藏" />{/if}
                    {if $topic.review}
                        &nbsp;<div class="topic-status">{bbs::getReviewStatName($topic.review)}</div>
                    {/if}
                    {if $topic.uinfo->hasPermission(UserInfo::DEBUFF_BLOCK_POST)}
                        &nbsp;<div class="topic-status">被禁言</div>
                    {/if}
                    {if $topic.locked == 2}
				    	&nbsp;<div class="topic-status">评论关闭</div>
			    	{elseif $topic.locked}
                        &nbsp;<div class="topic-status">被锁定</div>
                    {/if}
                    {if $topic.level < 0}
                        &nbsp;<div class="topic-status">被下沉</div>
                    {/if}
                </div>
            </div>
            <div class="topic-forum-name">
                <a href="bbs.forum.{$topic.forum_id}.{$BID}" class="topic-title">{$topic.forum_name}</a>
            </div>
            <div class="topic-reply-count">
                <a href="bbs.topic.{$topic.topic_id}.{$BID}">{$topic.reply_count}</a>
            </div>
        </li>
    {/foreach}
</ul>
