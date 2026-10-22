-- ============================================================
-- wechat 项目模拟数据初始化脚本
-- 说明：以 mapper/entity 代码为准重建 5 张表，保证字段与代码一一对应
-- 用法：mysql -h 127.0.0.1 -P 3306 -uroot -p wechat < seed.sql
-- 注意：脚本会先清空这 5 张表（自增主键一并重置）
-- ============================================================

-- 关闭外键检查，本脚本不依赖外键约束
SET FOREIGN_KEY_CHECKS = 0;

-- ---------- 建表（与代码实体保持一致）----------

DROP TABLE IF EXISTS `user`;
CREATE TABLE `user` (
  `uid`       int(11) NOT NULL AUTO_INCREMENT COMMENT '用户id',
  `email`     varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '邮箱(登录账号)',
  `password`  varchar(50)  COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '密码',
  `nickname`  varchar(50)  COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'userx' COMMENT '昵称',
  `avatar`    varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'https://api.dicebear.com/7.x/shapes/svg?seed=group30' COMMENT '头像',
  `create_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `address`   varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT '未设置' COMMENT '地址',
  `sign`      varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT '未设置' COMMENT '个性签名',
  PRIMARY KEY (`uid`),
  UNIQUE KEY `uk_user_email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户表';

DROP TABLE IF EXISTS `groups`;
CREATE TABLE `groups` (
  `group_id`    int(11) NOT NULL AUTO_INCREMENT COMMENT '群/私聊会话id',
  `group_name`  varchar(255) NOT NULL COMMENT '群名(私聊为创建时间戳字符串)',
  `group_avatar` varchar(255) DEFAULT 'https://api.dicebear.com/7.x/shapes/svg?seed=group30' COMMENT '群头像',
  `creator_id`  int(12) NOT NULL COMMENT '创建者uid',
  `create_at`   datetime NOT NULL COMMENT '创建时间',
  `multi`       int(11) NOT NULL DEFAULT '0' COMMENT '0=私聊 1=群聊',
  PRIMARY KEY (`group_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='群/私聊会话表';

DROP TABLE IF EXISTS `relationships`;
CREATE TABLE `relationships` (
  `id`       int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `group_id` int(11) NOT NULL COMMENT '群/会话id',
  `uid`      int(11) NOT NULL COMMENT '成员uid',
  `nickname` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '群内昵称',
  `avatar`   varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT 'https://api.dicebear.com/7.x/shapes/svg?seed=group30' COMMENT '群内头像',
  PRIMARY KEY (`id`),
  KEY `idx_rel_group` (`group_id`),
  KEY `idx_rel_uid` (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='会话成员关系表';

DROP TABLE IF EXISTS `messages`;
CREATE TABLE `messages` (
  `mid`      int(11) NOT NULL AUTO_INCREMENT COMMENT '消息id',
  `uid`      int(11) NOT NULL COMMENT '发送者uid',
  `group_id` int(11) NOT NULL COMMENT '所属会话id',
  `content`  mediumtext COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '消息内容',
  `send_at`  datetime DEFAULT CURRENT_TIMESTAMP COMMENT '发送时间',
  `back`     int(11) DEFAULT NULL COMMENT '是否撤回 1=已撤回',
  PRIMARY KEY (`mid`) USING BTREE,
  KEY `idx_msg_uid` (`uid`),
  KEY `idx_msg_group` (`group_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='消息表';

DROP TABLE IF EXISTS `temp`;
CREATE TABLE `temp` (
  `id`    int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `email` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '注册邮箱',
  `code`  varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '邮箱验证码',
  PRIMARY KEY (`id`),
  KEY `idx_temp_email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='邮箱验证码临时表';

-- ---------- 清空旧数据（重置自增）----------

TRUNCATE TABLE `messages`;
TRUNCATE TABLE `relationships`;
TRUNCATE TABLE `groups`;
TRUNCATE TABLE `temp`;
TRUNCATE TABLE `user`;

-- ---------- 用户数据 ----------
-- 账号：alice@demo.com / 123456   bob@demo.com / 123456 ...
-- 覆盖不同昵称/头像/签名，便于演示搜索、好友、群聊

INSERT INTO `user` (`uid`, `email`, `password`, `nickname`, `avatar`, `create_at`, `address`, `sign`) VALUES
(1,  'alice@demo.com', '123456', '爱丽丝',      'https://api.dicebear.com/7.x/avataaars/svg?seed=alice',   '2024-10-13 13:43:38', '四川成都',        '山高路远，看世界也找自己'),
(2,  'bob@demo.com',   '123456', '鲍勃',        'https://api.dicebear.com/7.x/avataaars/svg?seed=bob',     '2024-10-13 14:05:12', '北京朝阳',        '好好学习，天天向上'),
(3,  'carol@demo.com', '123456', ' Carol',      'https://api.dicebear.com/7.x/avataaars/svg?seed=carol',   '2024-10-14 09:20:44', '上海浦东',        '代码改变世界'),
(4,  'dave@demo.com',  '123456', '戴夫',        'https://api.dicebear.com/7.x/avataaars/svg?seed=dave',    '2024-10-15 16:32:01', '浙江杭州',        '慢慢来，比较快'),
(5,  'eve@demo.com',   '123456', '伊芙',        'https://api.dicebear.com/7.x/avataaars/svg?seed=eve',     '2024-10-16 11:08:57', '广东深圳',        '保持热爱，奔赴山海'),
(6,  'frank@demo.com', '123456', '弗兰克',      'https://api.dicebear.com/7.x/avataaars/svg?seed=frank',   '2024-10-17 20:44:23', '江苏南京',        '人生是旷野'),
(7,  'grace@demo.com', '123456', '格蕾丝',      'https://api.dicebear.com/7.x/avataaars/svg?seed=grace',   '2024-10-18 08:15:39', '湖北武汉',        '星光不问赶路人'),
(8,  'henry@demo.com', '123456', '亨利',        'https://api.dicebear.com/7.x/avataaars/svg?seed=henry',   '2024-10-19 19:37:52', '陕西西安',        '行胜于言');

-- ---------- 会话数据 ----------
-- 私聊会话：multi=0，群名沿用项目惯例（时间戳字符串）
-- 关系：每个私聊会话恰好 2 条 relationships，且 uid 互不相同（getShipGid / getGidByUid 依赖此约定）

-- 私聊会话（multi = 0）
INSERT INTO `groups` (`group_id`, `group_name`, `group_avatar`, `creator_id`, `create_at`, `multi`) VALUES
(11, '1728804850', 'https://api.dicebear.com/7.x/shapes/svg?seed=group30', 1, '2024-10-13 15:34:10', 0),  -- 1 <-> 2
(12, '1728822221', 'https://api.dicebear.com/7.x/shapes/svg?seed=group30', 1, '2024-10-13 20:23:41', 0),  -- 1 <-> 3
(13, '1728822971', 'https://api.dicebear.com/7.x/shapes/svg?seed=group30', 2, '2024-10-13 20:36:12', 0),  -- 2 <-> 3
(14, '1728833012', 'https://api.dicebear.com/7.x/shapes/svg?seed=group30', 3, '2024-10-14 10:12:05', 0),  -- 3 <-> 4
(15, '1728844023', 'https://api.dicebear.com/7.x/shapes/svg?seed=group30', 4, '2024-10-14 15:45:31', 0),  -- 4 <-> 5
(16, '1728855034', 'https://api.dicebear.com/7.x/shapes/svg?seed=group30', 1, '2024-10-15 09:28:19', 0),  -- 1 <-> 6
(17, '1728866045', 'https://api.dicebear.com/7.x/shapes/svg?seed=group30', 2, '2024-10-15 17:03:57', 0),  -- 2 <-> 7
(18, '1728877056', 'https://api.dicebear.com/7.x/shapes/svg?seed=group30', 5, '2024-10-16 13:36:02', 0),  -- 5 <-> 8
(19, '1728888067', 'https://api.dicebear.com/7.x/shapes/svg?seed=group30', 6, '2024-10-16 21:19:48', 0),  -- 6 <-> 7
(20, '1728899078', 'https://api.dicebear.com/7.x/shapes/svg?seed=group30', 7, '2024-10-17 08:52:26', 0);  -- 7 <-> 8

-- 群聊会话（multi = 1）
INSERT INTO `groups` (`group_id`, `group_name`, `group_avatar`, `creator_id`, `create_at`, `multi`) VALUES
(30, '代码改变世界',   'https://api.dicebear.com/7.x/shapes/svg?seed=group30', 1, '2024-10-20 10:00:00', 1),  -- 1 2 3 4 5
(31, '周末去哪儿玩',   'https://api.dicebear.com/7.x/shapes/svg?seed=group30', 2, '2024-10-25 18:30:00', 1),  -- 2 3 6 7
(32, '深夜食堂',       'https://api.dicebear.com/7.x/shapes/svg?seed=group30', 5, '2024-11-01 22:15:00', 1),  -- 5 6 8
(33, '全栈技术交流',   'https://api.dicebear.com/7.x/shapes/svg?seed=group30', 3, '2024-11-09 14:05:00', 1);  -- 1 2 3 4 5 6 7 8

-- 成员关系（私聊：每会话 2 人且 uid 不同）
INSERT INTO `relationships` (`group_id`, `uid`, `nickname`, `avatar`) VALUES
(11, 1, '爱丽丝', 'https://api.dicebear.com/7.x/avataaars/svg?seed=alice'),
(11, 2, '鲍勃',   'https://api.dicebear.com/7.x/avataaars/svg?seed=bob'),
(12, 1, '爱丽丝', 'https://api.dicebear.com/7.x/avataaars/svg?seed=alice'),
(12, 3, 'Carol',  'https://api.dicebear.com/7.x/avataaars/svg?seed=carol'),
(13, 2, '鲍勃',   'https://api.dicebear.com/7.x/avataaars/svg?seed=bob'),
(13, 3, 'Carol',  'https://api.dicebear.com/7.x/avataaars/svg?seed=carol'),
(14, 3, 'Carol',  'https://api.dicebear.com/7.x/avataaars/svg?seed=carol'),
(14, 4, '戴夫',   'https://api.dicebear.com/7.x/avataaars/svg?seed=dave'),
(15, 4, '戴夫',   'https://api.dicebear.com/7.x/avataaars/svg?seed=dave'),
(15, 5, '伊芙',   'https://api.dicebear.com/7.x/avataaars/svg?seed=eve'),
(16, 1, '爱丽丝', 'https://api.dicebear.com/7.x/avataaars/svg?seed=alice'),
(16, 6, '弗兰克', 'https://api.dicebear.com/7.x/avataaars/svg?seed=frank'),
(17, 2, '鲍勃',   'https://api.dicebear.com/7.x/avataaars/svg?seed=bob'),
(17, 7, '格蕾丝', 'https://api.dicebear.com/7.x/avataaars/svg?seed=grace'),
(18, 5, '伊芙',   'https://api.dicebear.com/7.x/avataaars/svg?seed=eve'),
(18, 8, '亨利',   'https://api.dicebear.com/7.x/avataaars/svg?seed=henry'),
(19, 6, '弗兰克', 'https://api.dicebear.com/7.x/avataaars/svg?seed=frank'),
(19, 7, '格蕾丝', 'https://api.dicebear.com/7.x/avataaars/svg?seed=grace'),
(20, 7, '格蕾丝', 'https://api.dicebear.com/7.x/avataaars/svg?seed=grace'),
(20, 8, '亨利',   'https://api.dicebear.com/7.x/avataaars/svg?seed=henry');

-- 成员关系（群聊：多人）
INSERT INTO `relationships` (`group_id`, `uid`, `nickname`, `avatar`) VALUES
(30, 1, '爱丽丝', 'https://api.dicebear.com/7.x/avataaars/svg?seed=alice'),
(30, 2, '鲍勃',   'https://api.dicebear.com/7.x/avataaars/svg?seed=bob'),
(30, 3, 'Carol',  'https://api.dicebear.com/7.x/avataaars/svg?seed=carol'),
(30, 4, '戴夫',   'https://api.dicebear.com/7.x/avataaars/svg?seed=dave'),
(30, 5, '伊芙',   'https://api.dicebear.com/7.x/avataaars/svg?seed=eve'),
(31, 2, '鲍勃',   'https://api.dicebear.com/7.x/avataaars/svg?seed=bob'),
(31, 3, 'Carol',  'https://api.dicebear.com/7.x/avataaars/svg?seed=carol'),
(31, 6, '弗兰克', 'https://api.dicebear.com/7.x/avataaars/svg?seed=frank'),
(31, 7, '格蕾丝', 'https://api.dicebear.com/7.x/avataaars/svg?seed=grace'),
(32, 5, '伊芙',   'https://api.dicebear.com/7.x/avataaars/svg?seed=eve'),
(32, 6, '弗兰克', 'https://api.dicebear.com/7.x/avataaars/svg?seed=frank'),
(32, 8, '亨利',   'https://api.dicebear.com/7.x/avataaars/svg?seed=henry'),
(33, 1, '爱丽丝', 'https://api.dicebear.com/7.x/avataaars/svg?seed=alice'),
(33, 2, '鲍勃',   'https://api.dicebear.com/7.x/avataaars/svg?seed=bob'),
(33, 3, 'Carol',  'https://api.dicebear.com/7.x/avataaars/svg?seed=carol'),
(33, 4, '戴夫',   'https://api.dicebear.com/7.x/avataaars/svg?seed=dave'),
(33, 5, '伊芙',   'https://api.dicebear.com/7.x/avataaars/svg?seed=eve'),
(33, 6, '弗兰克', 'https://api.dicebear.com/7.x/avataaars/svg?seed=frank'),
(33, 7, '格蕾丝', 'https://api.dicebear.com/7.x/avataaars/svg?seed=grace'),
(33, 8, '亨利',   'https://api.dicebear.com/7.x/avataaars/svg?seed=henry');

-- ---------- 消息数据 ----------
-- 规则：uid 必须是该 group_id 的成员（满足 relationships）
-- 私聊消息 group_id 与 uid 互换，模拟双向对话

INSERT INTO `messages` (`mid`, `uid`, `group_id`, `content`, `send_at`, `back`) VALUES
-- 私聊 11：爱丽丝(1) <-> 鲍勃(2)
(101, 1, 11, '在吗？有个需求想跟你对一下', '2024-11-28 21:25:00', 0),
(102, 2, 11, '在的，说吧',               '2024-11-28 21:25:47', 0),
(103, 1, 11, '消息列表的表结构要加 back 字段，用来标记撤回', '2024-11-28 21:26:30', 0),
(104, 2, 11, '可以，我改一下 mapper',   '2024-11-28 21:27:12', 0),
(105, 1, 11, '辛苦，搞完我这边联调',   '2024-11-28 21:28:05', 1),

-- 私聊 12：爱丽丝(1) <-> Carol(3)
(106, 3, 12, 'Spring Boot 的拦截器注册了吗？', '2024-11-29 09:58:24', 0),
(107, 1, 12, '注册了，WebConfig 里排除登录和注册接口', '2024-11-29 09:59:10', 0),
(108, 3, 12, 'OK，我测一下 /user 接口', '2024-11-29 10:01:33', 0),

-- 私聊 13：鲍勃(2) <-> Carol(3)
(109, 2, 13, '周末的代码评审改到周五下午了', '2024-12-01 14:15:54', 0),
(110, 3, 13, '收到，我把冲突的分支先 rebase 一下', '2024-12-01 14:16:40', 0),

-- 私聊 14：Carol(3) <-> 戴夫(4)
(111, 4, 14, '群聊的成员昵称是取 relationships 里的 nickname 吗？', '2024-12-05 19:58:54', 0),
(112, 3, 14, '对，建群/加好友时会把 user 的 nickname 写进去', '2024-12-05 19:59:20', 0),
(113, 4, 14, '明白了', '2024-12-05 20:00:11', 0),

-- 私聊 15：戴夫(4) <-> 伊芙(5)
(114, 5, 15, '测试环境数据库重建好了吗？', '2024-12-06 17:43:43', 0),
(115, 4, 15, '好了，导入的是服务端的 dump', '2024-12-06 17:44:02', 0),
(116, 5, 15, '好，我开始跑用例', '2024-12-06 17:44:39', 0),

-- 私聊 16：爱丽丝(1) <-> 弗兰克(6)
(117, 1, 16, '这个 Vue 项目用 Electron 打包可行吗？', '2024-12-09 11:17:44', 0),
(118, 6, 16, '可以，但 electron 镜像要配国内源，不然卡住', '2024-12-09 11:18:12', 0),
(119, 1, 16, '好嘞，我去配 npmmirror', '2024-12-09 11:18:45', 0),

-- 私聊 17：鲍勃(2) <-> 格蕾丝(7)
(120, 7, 17, '帮我看看这个 SQL 为什么报 1064', '2024-12-11 16:25:39', 0),
(121, 2, 17, "是 groups 吧，这是 MySQL 8 的保留字，要加反引号", '2024-12-11 16:25:58', 0),
(122, 7, 17, '果然是，谢谢！', '2024-12-11 16:26:20', 0),

-- 私聊 18：伊芙(5) <-> 亨利(8)
(123, 8, 18, '接口返回的 data 要用 List 包一层吗？', '2024-12-12 14:05:08', 0),
(124, 5, 18, '统一用 Response 包装，前端好处理', '2024-12-12 14:05:26', 0),

-- 私聊 19：弗兰克(6) <-> 格蕾丝(7)
(125, 6, 19, 'CI 又挂了，看看是不是依赖装不上', '2024-12-12 14:29:05', 0),
(126, 7, 19, '嗯，我拉一下日志', '2024-12-12 14:29:41', 0),

-- 私聊 20：格蕾丝(7) <-> 亨利(8)
(127, 8, 20, '今天的站会几点？', '2024-12-12 14:34:43', 0),
(128, 7, 20, '15:00，别忘了更新看板', '2024-12-12 14:35:18', 0);

-- 群聊 30：代码改变世界（1 2 3 4 5）
INSERT INTO `messages` (`mid`, `uid`, `group_id`, `content`, `send_at`, `back`) VALUES
(201, 1, 30, '各位，新版本的接口文档我放到 wiki 了', '2024-10-20 10:05:00', 0),
(202, 2, 30, '收到，我按文档先写前端页面', '2024-10-20 10:06:12', 0),
(203, 3, 30, 'JWT 拦截器的白名单我列在 README 里了', '2024-10-20 10:07:45', 0),
(204, 4, 30, '消息表的索引我加了 uid 和 group_id 两个', '2024-10-20 10:08:33', 0),
(205, 5, 30, '我这边联调好友添加接口，返回结构对吗？', '2024-10-20 10:09:21', 0),
(206, 1, 30, 'addFriend 成功时直接返回对方 User 对象', '2024-10-20 10:10:05', 0),
(207, 2, 30, '明白', '2024-10-20 10:10:47', 1);

-- 群聊 31：周末去哪儿玩（2 3 6 7）
INSERT INTO `messages` (`mid`, `uid`, `group_id`, `content`, `send_at`, `back`) VALUES
(208, 2, 31, '周末有人想去爬山吗？', '2024-10-25 18:31:00', 0),
(209, 6, 31, '我可以，来回大概多久？', '2024-10-25 18:32:14', 0),
(210, 2, 31, '单程 1 小时，早上八点出发', '2024-10-25 18:33:02', 0),
(211, 7, 31, '带点水和零食吧', '2024-10-25 18:33:48', 0),
(212, 3, 31, '算了我就不去了，周末加班', '2024-10-25 18:34:26', 1);

-- 群聊 32：深夜食堂（5 6 8）
INSERT INTO `messages` (`mid`, `uid`, `group_id`, `content`, `send_at`, `back`) VALUES
(213, 5, 32, '周五晚上吃火锅，有人吗', '2024-11-01 22:16:00', 0),
(214, 8, 32, '我去！谁请客', '2024-11-01 22:16:35', 0),
(215, 6, 32, 'AA 吧，我知道一家不错的店', '2024-11-01 22:17:09', 0),
(216, 5, 32, '行，我把地址发群里', '2024-11-01 22:18:00', 0);

-- 群聊 33：全栈技术交流（1-8）
INSERT INTO `messages` (`mid`, `uid`, `group_id`, `content`, `send_at`, `back`) VALUES
(217, 1, 33, '周一分享会我讲 Spring Boot 拦截器，有建议吗', '2024-11-09 14:06:00', 0),
(218, 2, 33, '可以加个实际的鉴权例子', '2024-11-09 14:06:52', 0),
(219, 4, 33, 'Python 那边要不要也讲讲 FastAPI 的中间件', '2024-11-09 14:07:41', 0),
(220, 6, 33, 'MySQL 8 和 5.7 的行为差异也可以提一下', '2024-11-09 14:08:23', 0),
(221, 7, 33, '保留字那个坑就很典型', '2024-11-09 14:09:10', 0),
(222, 8, 33, '我整理一份常见问题 list 发出来', '2024-11-09 14:10:02', 0),
(223, 3, 33, '辛苦，我先记一下', '2024-11-09 14:10:55', 0),
(224, 5, 33, '线上见', '2024-11-09 14:11:30', 1);

-- ---------- 验证码临时数据（注册流程用）----------

INSERT INTO `temp` (`id`, `email`, `code`) VALUES
(1, 'test@demo.com',      '123456'),
(2, 'pending@demo.com',   '654321'),
(3, 'newuser@demo.com',   '111111');

-- 恢复外键检查
SET FOREIGN_KEY_CHECKS = 1;

-- 数据校验
SELECT 'user' AS tbl,            COUNT(*) AS cnt FROM `user`          UNION ALL
SELECT 'groups(私聊)',           COUNT(*) FROM `groups` WHERE multi = 0 UNION ALL
SELECT 'groups(群聊)',           COUNT(*) FROM `groups` WHERE multi = 1 UNION ALL
SELECT 'relationships',          COUNT(*) FROM `relationships`        UNION ALL
SELECT 'messages',               COUNT(*) FROM `messages`             UNION ALL
SELECT 'temp',                   COUNT(*) FROM `temp`;
