drop table comment_f;
drop table comment_hastag_tag_f;
drop table forum_f;
drop table forum_hasmember_person_f;
drop table forum_hastag_tag_f;
drop table organisation_f;
drop table person_f;
drop table person_email_emailaddress_f;
drop table person_hasinterest_tag_f;
drop table person_knows_person_f;
drop table person_likes_post_f;
drop table person_likes_comment_f;
drop table person_speaks_language_f;
drop table person_studyat_organisation_f;
drop table person_workat_organisation_f;
drop table place_f;
drop table post_f;
drop table post_hastag_tag_f;
drop table tagclass_f;
drop table tagclass_issubclassof_tagclass_f;
drop table tag_f;
drop table tag_hastype_tagclass_f;


drop table comment_hasCreator_person_0_0;
drop table comment_isLocatedIn_place_0_0;
drop table comment_replyOf_post_0_0;
drop table comment_replyOf_comment_0_0;
drop table forum_hasModerator_person_0_0;
drop table organisation_isLocatedIn_place_0_0;
drop table person_isLocatedIn_place_0_0;
drop table place_isPartOf_place_0_0;
drop table post_hasCreator_person_0_0;
drop table forum_containerOf_post_0_0;
drop table post_isLocatedIn_place_0_0;

-- create a table for representing comments.
create table comment_f (
    c_commentid bigint not null,
    c_creationdate timestamp with time zone not null,
    c_locationip varchar not null,
    c_browserused varchar not null,
    c_content varchar not null,
    c_length int not null
    -- ,
    -- c_creator bigint,
    -- c_place bigint,
    -- c_replyofpost bigint,
    -- c_replyofcomment bigint
);

\copy comment_f from '/data/social_network/comment_0_0.csv' delimiter '|' CSV HEADER ENCODING 'UTF8';

ALTER TABLE comment_f ADD c_creator bigint;
ALTER TABLE comment_f ADD c_place bigint;
ALTER TABLE comment_f ADD c_replyofpost bigint;
ALTER TABLE comment_f ADD c_replyofcomment bigint;

create table comment_hasCreator_person_0_0 (
    pri_key bigint primary key,
    fgn_key bigint
);

\copy comment_hasCreator_person_0_0 from '/data/social_network/comment_hasCreator_person_0_0.csv' delimiter '|' CSV HEADER ENCODING 'UTF8';

update comment_f
    set c_creator = comment_hasCreator_person_0_0.fgn_key
    from comment_hasCreator_person_0_0
    where comment_f.c_commentid = comment_hasCreator_person_0_0.pri_key;

------------------
create table comment_isLocatedIn_place_0_0 (
    pri_key bigint primary key,
    fgn_key bigint
);

\copy comment_isLocatedIn_place_0_0 from '/data/social_network/comment_isLocatedIn_place_0_0.csv' delimiter '|' CSV HEADER ENCODING 'UTF8';

update comment_f
    set c_place = comment_isLocatedIn_place_0_0.fgn_key
    from comment_isLocatedIn_place_0_0
    where comment_f.c_commentid = comment_isLocatedIn_place_0_0.pri_key;

------------------
create table comment_replyOf_post_0_0 (
    pri_key bigint primary key,
    fgn_key bigint
);

\copy comment_replyOf_post_0_0 from '/data/social_network/comment_replyOf_post_0_0.csv' delimiter '|' CSV HEADER ENCODING 'UTF8';

update comment_f
    set c_place = comment_replyOf_post_0_0.fgn_key
    from comment_replyOf_post_0_0
    where comment_f.c_commentid = comment_replyOf_post_0_0.pri_key;

------------------
create table comment_replyOf_comment_0_0 (
    pri_key bigint primary key,
    fgn_key bigint
);

\copy comment_replyOf_comment_0_0 from '/data/social_network/comment_replyOf_comment_0_0.csv' delimiter '|' CSV HEADER ENCODING 'UTF8';

update comment_f
    set c_place = comment_replyOf_comment_0_0.fgn_key
    from comment_replyOf_comment_0_0
    where comment_f.c_commentid = comment_replyOf_comment_0_0.pri_key;



create table comment_hastag_tag_f (
   ct_commentid bigint not null,
   ct_tagid bigint not null
);

\copy comment_hastag_tag_f from '/data/social_network/comment_hasTag_tag_0_0.csv' delimiter '|' CSV HEADER ENCODING 'UTF8';

create table forum_f (
   f_forumid bigint not null,
   f_title varchar not null,
   f_creationdate timestamp with time zone not null
   -- ,
   -- f_moderator bigint not null
);

\copy forum_f from '/data/social_network/forum_0_0.csv' delimiter '|' CSV HEADER ENCODING 'UTF8';

ALTER TABLE forum_f ADD f_moderator bigint;

create table forum_hasModerator_person_0_0 (
    pri_key bigint primary key,
    fgn_key bigint
);

\copy forum_hasModerator_person_0_0 from '/data/social_network/forum_hasModerator_person_0_0.csv' delimiter '|' CSV HEADER ENCODING 'UTF8';

update forum_f
    set f_moderator = forum_hasModerator_person_0_0.fgn_key
    from forum_hasModerator_person_0_0
    where forum_f.f_forumid = forum_hasModerator_person_0_0.pri_key;


create table forum_hasmember_person_f (
   fp_forumid bigint not null,
   fp_personid bigint not null,
   fp_creationdate timestamp with time zone not null
);

\copy forum_hasmember_person_f from '/data/social_network/forum_hasMember_person_0_0.csv' delimiter '|' CSV HEADER ENCODING 'UTF8';


create table forum_hastag_tag_f (
   ft_forumid bigint not null,
   ft_tagid bigint not null
);

\copy forum_hastag_tag_f from '/data/social_network/forum_hasTag_tag_0_0.csv' delimiter '|' CSV HEADER ENCODING 'UTF8';


create table organisation_f (
   o_organisationid bigint not null,
   o_type varchar not null,
   o_name varchar not null,
   o_url varchar not null
--    ,
--    o_placeid bigint not null
);

\copy organisation_f from '/data/social_network/organisation_0_0.csv' delimiter '|' CSV HEADER ENCODING 'UTF8';

ALTER TABLE organisation_f ADD o_placeid bigint;

create table organisation_isLocatedIn_place_0_0 (
    pri_key bigint primary key,
    fgn_key bigint
);

\copy organisation_isLocatedIn_place_0_0 from '/data/social_network/organisation_isLocatedIn_place_0_0.csv' delimiter '|' CSV HEADER ENCODING 'UTF8';

update organisation_f
    set o_placeid = organisation_isLocatedIn_place_0_0.fgn_key
    from organisation_isLocatedIn_place_0_0
    where organisation_f.o_organisationid = organisation_isLocatedIn_place_0_0.pri_key;


create table person_f (
   p_personid bigint not null,
   p_firstname varchar not null,
   p_lastname varchar not null,
   p_gender varchar not null,
   p_birthday date not null,
   p_creationdate timestamp with time zone not null,
   p_locationip varchar not null,
   p_browserused varchar not null
--    ,
--    p_placeid bigint not null
);

\copy person_f from '/data/social_network/person_0_0.csv' delimiter '|' CSV HEADER ENCODING 'UTF8';

ALTER TABLE person_f ADD p_placeid bigint;

create table person_isLocatedIn_place_0_0 (
    pri_key bigint primary key,
    fgn_key bigint
);

\copy person_isLocatedIn_place_0_0 from '/data/social_network/person_isLocatedIn_place_0_0.csv' delimiter '|' CSV HEADER ENCODING 'UTF8';

update person_f
    set p_placeid = person_isLocatedIn_place_0_0.fgn_key
    from person_isLocatedIn_place_0_0
    where person_f.p_personid = person_isLocatedIn_place_0_0.pri_key;


create table person_email_emailaddress_f (
   pe_personid bigint not null,
   pe_email varchar not null
);

\copy person_email_emailaddress_f from '/data/social_network/person_email_emailaddress_0_0.csv' delimiter '|' CSV HEADER ENCODING 'UTF8';


create table person_hasinterest_tag_f (
   pt_personid bigint not null,
   pt_tagid bigint not null
);

\copy person_hasinterest_tag_f from '/data/social_network/person_hasInterest_tag_0_0.csv' delimiter '|' CSV HEADER ENCODING 'UTF8';

create table person_knows_person_f (
   pp_person1id bigint not null,
   pp_person2id bigint not null,
  pp_creationdate timestamp with time zone
);

\copy person_knows_person_f from '/data/social_network/person_knows_person_0_0.csv' delimiter '|' CSV HEADER ENCODING 'UTF8';

create table person_likes_post_f (
   pp_personid bigint not null,
   pp_postid bigint not null,
   pp_creationdate timestamp with time zone not null
);

\copy person_likes_post_f from '/data/social_network/person_likes_post_0_0.csv' delimiter '|' CSV HEADER ENCODING 'UTF8';


create table person_likes_comment_f (
   pp_personid bigint not null,
   pp_postid bigint not null,
   pp_creationdate timestamp with time zone not null
);

\copy person_likes_comment_f from '/data/social_network/person_likes_comment_0_0.csv' delimiter '|' CSV HEADER ENCODING 'UTF8';


create table person_speaks_language_f (
   pl_personid bigint not null,
   pl_language varchar not null
);

\copy person_speaks_language_f from '/data/social_network/person_speaks_language_0_0.csv' delimiter '|' CSV HEADER ENCODING 'UTF8';

create table person_studyat_organisation_f (
   po_organisationid bigint not null,
   po_personid bigint not null,
   po_classyear int not null
);

\copy person_studyat_organisation_f from '/data/social_network/person_studyAt_organisation_0_0.csv' delimiter '|' CSV HEADER ENCODING 'UTF8';

create table person_workat_organisation_f (
   po_organisationid bigint not null,
   po_personid bigint not null,
   po_workfrom int not null
);

\copy person_workat_organisation_f from '/data/social_network/person_workAt_organisation_0_0.csv' delimiter '|' CSV HEADER ENCODING 'UTF8';

create table place_f (
   p_placeid bigint not null,
   p_name varchar not null,
   p_url varchar not null,
   p_type varchar not null
--    ,
--    p_ispartof bigint
);

\copy place_f from '/data/social_network/place_0_0.csv' delimiter '|' CSV HEADER ENCODING 'UTF8';

ALTER TABLE place_f ADD p_ispartof bigint;

create table place_isPartOf_place_0_0 (
    pri_key bigint primary key,
    fgn_key bigint
);

\copy place_isPartOf_place_0_0 from '/data/social_network/place_isPartOf_place_0_0.csv' delimiter '|' CSV HEADER ENCODING 'UTF8';

update place_f
    set p_ispartof = place_isPartOf_place_0_0.fgn_key
    from place_isPartOf_place_0_0
    where place_f.p_placeid = place_isPartOf_place_0_0.pri_key;


create table post_f (
    p_postid bigint not null,
    p_imagefile varchar,
    p_creationdate timestamp with time zone not null,
    p_locationip varchar not null,
    p_browserused varchar not null,
    p_language varchar,
    p_content varchar,
    p_length int not null
    -- ,
    -- p_creator bigint not null,
    -- p_forumid bigint not null,
    -- p_placeid bigint not null
);

\copy post_f from '/data/social_network/post_0_0.csv' delimiter '|' CSV HEADER ENCODING 'UTF8';

ALTER TABLE post_f ADD p_creator bigint;
ALTER TABLE post_f ADD p_forumid bigint;
ALTER TABLE post_f ADD p_placeid bigint;

create table post_hasCreator_person_0_0 (
    pri_key bigint primary key,
    fgn_key bigint
);

\copy post_hasCreator_person_0_0 from '/data/social_network/post_hasCreator_person_0_0.csv' delimiter '|' CSV HEADER ENCODING 'UTF8';

update post_f
    set p_creator = post_hasCreator_person_0_0.fgn_key
    from post_hasCreator_person_0_0
    where post_f.p_postid = post_hasCreator_person_0_0.pri_key;

create table forum_containerOf_post_0_0 (
    forum_id bigint,
    post_id bigint
);

\copy forum_containerOf_post_0_0 from '/data/social_network/forum_containerOf_post_0_0.csv' delimiter '|' CSV HEADER ENCODING 'UTF8';

-- forum_containerOf_post_0_0 is reversed relation
update post_f
    set p_forumid = forum_containerOf_post_0_0.forum_id
    from forum_containerOf_post_0_0
    where post_f.p_postid = forum_containerOf_post_0_0.post_id;


create table post_isLocatedIn_place_0_0 (
    pri_key bigint primary key,
    fgn_key bigint
);

\copy post_isLocatedIn_place_0_0 from '/data/social_network/post_isLocatedIn_place_0_0.csv' delimiter '|' CSV HEADER ENCODING 'UTF8';

update post_f
    set p_placeid = post_isLocatedIn_place_0_0.fgn_key
    from post_isLocatedIn_place_0_0
    where post_f.p_postid = post_isLocatedIn_place_0_0.pri_key;



create table post_hastag_tag_f (
   pt_postid bigint not null,
   pt_tagid bigint not null
);

\copy post_hastag_tag_f from '/data/social_network/post_hasTag_tag_0_0.csv' delimiter '|' CSV HEADER ENCODING 'UTF8';

create table tagclass_f (
   t_tagclassid bigint not null,
   t_name varchar not null,
   t_url varchar not null
);

\copy tagclass_f from '/data/social_network/tagclass_0_0.csv' delimiter '|' CSV HEADER ENCODING 'UTF8';

create table tagclass_issubclassof_tagclass_f (
   tt_tagclass1id bigint not null,
   tt_tagclass2id bigint not null
);

\copy tagclass_issubclassof_tagclass_f from '/data/social_network/tagclass_isSubclassOf_tagclass_0_0.csv' delimiter '|' CSV HEADER ENCODING 'UTF8';

create table tag_f (
   t_tagid bigint not null,
   t_name varchar not null,
   t_url varchar not null
);

\copy tag_f from '/data/social_network/tag_0_0.csv' delimiter '|' CSV HEADER ENCODING 'UTF8';

create table tag_hastype_tagclass_f (
   tt_tagid bigint not null,
   tt_tagclassid bigint not null
);

\copy tag_hastype_tagclass_f from '/data/social_network/tag_hasType_tagclass_0_0.csv' delimiter '|' CSV HEADER ENCODING 'UTF8';

-- now final step, populate real tables from these temporary tables
insert into likes select pp_personid, pp_postid, extract(epoch from pp_creationdate) * 1000 from person_likes_post_f;

insert into likes select pp_personid, pp_postid + 0, extract(epoch from pp_creationdate) * 1000 from person_likes_comment_f;

insert into post_tag select ct_commentid + 0, ct_tagid from comment_hastag_tag_f;

insert into post_tag select * from post_hastag_tag_f;

insert into post(ps_postid, ps_imagefile, ps_creationdate, ps_locationip, ps_browserused, ps_language, ps_content, ps_length, ps_creatorid, ps_locationid, ps_forumid, ps_p_creatorid)
select p_postid, case when p_imagefile = '' then null else p_imagefile end, extract(epoch from p_creationdate) * 1000,
       p_locationip,
       p_browserused, p_language, p_content, p_length, p_creator, p_placeid, p_forumid, p_creator
from post_f;

insert into post(ps_postid, ps_creationdate, ps_locationip, ps_browserused, ps_content, ps_length, ps_creatorid, ps_locationid, ps_replyof)
select (c_commentid + 0), extract(epoch from c_creationdate) * 1000,
       c_locationip,
      c_browserused, c_content, c_length, c_creator, c_place, (case when c_replyofcomment is not null then (c_replyofcomment + 0) else c_replyofpost  end)
    from comment_f;

insert into forum_person select fp_forumid, fp_personid, extract(epoch from fp_creationdate) * 1000 from forum_hasmember_person_f;

insert into forum_tag select * from forum_hastag_tag_f;

insert into forum(f_forumid, f_title, f_creationdate, f_moderatorid) select f_forumid, f_title, extract(epoch from f_creationdate) * 1000, f_moderator from forum_f;

insert into person_company select * from person_workat_organisation_f;

insert into person_university select * from person_studyat_organisation_f;

insert into organisation select o_organisationid, o_type, o_name, o_url, o_placeid from organisation_f;

insert into person_email select * from person_email_emailaddress_f;

insert into person_tag select * from person_hasinterest_tag_f;

insert into person_language select * from person_speaks_language_f;

-- this is the only bi-directional edge in social network model
insert into knows select pp_person1id, pp_person2id, extract(epoch from pp_creationdate) * 1000 from person_knows_person_f;
insert into knows select pp_person2id, pp_person1id, extract(epoch from pp_creationdate) * 1000 from person_knows_person_f;

insert into person (   p_personid, p_firstname, p_lastname, p_gender, p_birthday, p_creationdate, p_locationip, p_browserused, p_placeid)
select p_personid, p_firstname, p_lastname, p_gender, extract(epoch from p_birthday::timestamptz) * 1000, extract(epoch from p_creationdate) * 1000,
       p_locationip,
       p_browserused, p_placeid
from person_f;

insert into place select p_placeid, p_name, p_url, p_type, p_ispartof from place_f;

insert into tag_tagclass select * from tag_hastype_tagclass_f;

insert into subclass select * from tagclass_issubclassof_tagclass_f;

insert into tagclass select * from tagclass_f;

insert into tag select * from tag_f;

