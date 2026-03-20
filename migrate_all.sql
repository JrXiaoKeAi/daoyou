CREATE TABLE "wanjiedaoyou_artifacts" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"cultivator_id" uuid NOT NULL,
	"name" varchar(100) NOT NULL,
	"slot" varchar(20) NOT NULL,
	"element" varchar(10) NOT NULL,
	"bonus" jsonb NOT NULL,
	"special_effects" jsonb DEFAULT '[]'::jsonb,
	"curses" jsonb DEFAULT '[]'::jsonb,
	"created_at" timestamp DEFAULT now()
);
--> statement-breakpoint
CREATE TABLE "wanjiedaoyou_consumables" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"cultivator_id" uuid NOT NULL,
	"name" varchar(100) NOT NULL,
	"type" varchar(20) NOT NULL,
	"effect" jsonb,
	"created_at" timestamp DEFAULT now()
);
--> statement-breakpoint
CREATE TABLE "wanjiedaoyou_cultivation_techniques" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"cultivator_id" uuid NOT NULL,
	"name" varchar(100) NOT NULL,
	"bonus" jsonb NOT NULL,
	"required_realm" varchar(20) NOT NULL,
	"created_at" timestamp DEFAULT now()
);
--> statement-breakpoint
CREATE TABLE "wanjiedaoyou_cultivators" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"user_id" uuid NOT NULL,
	"name" varchar(100) NOT NULL,
	"gender" varchar(10),
	"origin" varchar(100),
	"personality" text,
	"background" text,
	"prompt" text NOT NULL,
	"realm" varchar(20) NOT NULL,
	"realm_stage" varchar(10) NOT NULL,
	"age" integer DEFAULT 18 NOT NULL,
	"lifespan" integer DEFAULT 100 NOT NULL,
	"vitality" integer NOT NULL,
	"spirit" integer NOT NULL,
	"wisdom" integer NOT NULL,
	"speed" integer NOT NULL,
	"willpower" integer NOT NULL,
	"max_skills" integer DEFAULT 4 NOT NULL,
	"created_at" timestamp DEFAULT now(),
	"updated_at" timestamp DEFAULT now()
);
--> statement-breakpoint
CREATE TABLE "wanjiedaoyou_equipped_items" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"cultivator_id" uuid NOT NULL,
	"weapon_id" uuid,
	"armor_id" uuid,
	"accessory_id" uuid,
	"created_at" timestamp DEFAULT now(),
	"updated_at" timestamp DEFAULT now(),
	CONSTRAINT "wanjiedaoyou_equipped_items_cultivator_id_unique" UNIQUE("cultivator_id")
);
--> statement-breakpoint
CREATE TABLE "wanjiedaoyou_pre_heaven_fates" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"cultivator_id" uuid NOT NULL,
	"name" varchar(100) NOT NULL,
	"type" varchar(10) NOT NULL,
	"attribute_mod" jsonb NOT NULL,
	"description" text,
	"created_at" timestamp DEFAULT now()
);
--> statement-breakpoint
CREATE TABLE "wanjiedaoyou_skills" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"cultivator_id" uuid NOT NULL,
	"name" varchar(100) NOT NULL,
	"type" varchar(20) NOT NULL,
	"element" varchar(10) NOT NULL,
	"power" integer NOT NULL,
	"cost" integer DEFAULT 0,
	"cooldown" integer DEFAULT 0 NOT NULL,
	"effect" varchar(50),
	"duration" integer,
	"target_self" integer DEFAULT 0,
	"created_at" timestamp DEFAULT now()
);
--> statement-breakpoint
CREATE TABLE "wanjiedaoyou_spiritual_roots" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"cultivator_id" uuid NOT NULL,
	"element" varchar(10) NOT NULL,
	"strength" integer NOT NULL,
	"created_at" timestamp DEFAULT now()
);
--> statement-breakpoint
CREATE TABLE "wanjiedaoyou_temp_cultivators" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"user_id" uuid NOT NULL,
	"cultivator_data" jsonb NOT NULL,
	"created_at" timestamp DEFAULT now(),
	"expires_at" timestamp
);
--> statement-breakpoint
ALTER TABLE "wanjiedaoyou_artifacts" ADD CONSTRAINT "wanjiedaoyou_artifacts_cultivator_id_wanjiedaoyou_cultivators_id_fk" FOREIGN KEY ("cultivator_id") REFERENCES "public"."wanjiedaoyou_cultivators"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "wanjiedaoyou_consumables" ADD CONSTRAINT "wanjiedaoyou_consumables_cultivator_id_wanjiedaoyou_cultivators_id_fk" FOREIGN KEY ("cultivator_id") REFERENCES "public"."wanjiedaoyou_cultivators"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "wanjiedaoyou_cultivation_techniques" ADD CONSTRAINT "wanjiedaoyou_cultivation_techniques_cultivator_id_wanjiedaoyou_cultivators_id_fk" FOREIGN KEY ("cultivator_id") REFERENCES "public"."wanjiedaoyou_cultivators"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "wanjiedaoyou_equipped_items" ADD CONSTRAINT "wanjiedaoyou_equipped_items_cultivator_id_wanjiedaoyou_cultivators_id_fk" FOREIGN KEY ("cultivator_id") REFERENCES "public"."wanjiedaoyou_cultivators"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "wanjiedaoyou_equipped_items" ADD CONSTRAINT "wanjiedaoyou_equipped_items_weapon_id_wanjiedaoyou_artifacts_id_fk" FOREIGN KEY ("weapon_id") REFERENCES "public"."wanjiedaoyou_artifacts"("id") ON DELETE set null ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "wanjiedaoyou_equipped_items" ADD CONSTRAINT "wanjiedaoyou_equipped_items_armor_id_wanjiedaoyou_artifacts_id_fk" FOREIGN KEY ("armor_id") REFERENCES "public"."wanjiedaoyou_artifacts"("id") ON DELETE set null ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "wanjiedaoyou_equipped_items" ADD CONSTRAINT "wanjiedaoyou_equipped_items_accessory_id_wanjiedaoyou_artifacts_id_fk" FOREIGN KEY ("accessory_id") REFERENCES "public"."wanjiedaoyou_artifacts"("id") ON DELETE set null ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "wanjiedaoyou_pre_heaven_fates" ADD CONSTRAINT "wanjiedaoyou_pre_heaven_fates_cultivator_id_wanjiedaoyou_cultivators_id_fk" FOREIGN KEY ("cultivator_id") REFERENCES "public"."wanjiedaoyou_cultivators"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "wanjiedaoyou_skills" ADD CONSTRAINT "wanjiedaoyou_skills_cultivator_id_wanjiedaoyou_cultivators_id_fk" FOREIGN KEY ("cultivator_id") REFERENCES "public"."wanjiedaoyou_cultivators"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "wanjiedaoyou_spiritual_roots" ADD CONSTRAINT "wanjiedaoyou_spiritual_roots_cultivator_id_wanjiedaoyou_cultivators_id_fk" FOREIGN KEY ("cultivator_id") REFERENCES "public"."wanjiedaoyou_cultivators"("id") ON DELETE cascade ON UPDATE no action;
CREATE TABLE "wanjiedaoyou_battle_records" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"user_id" uuid NOT NULL,
	"cultivator_id" uuid NOT NULL,
	"battle_result" jsonb NOT NULL,
	"battle_report" text,
	"created_at" timestamp DEFAULT now() NOT NULL
);
--> statement-breakpoint
ALTER TABLE "wanjiedaoyou_battle_records" ADD CONSTRAINT "wanjiedaoyou_battle_records_cultivator_id_wanjiedaoyou_cultivators_id_fk" FOREIGN KEY ("cultivator_id") REFERENCES "public"."wanjiedaoyou_cultivators"("id") ON DELETE cascade ON UPDATE no action;
ALTER TABLE "wanjiedaoyou_cultivation_techniques" ADD COLUMN "grade" varchar(20);--> statement-breakpoint
ALTER TABLE "wanjiedaoyou_pre_heaven_fates" ADD COLUMN "quality" varchar(10);--> statement-breakpoint
ALTER TABLE "wanjiedaoyou_skills" ADD COLUMN "grade" varchar(20);--> statement-breakpoint
ALTER TABLE "wanjiedaoyou_spiritual_roots" ADD COLUMN "grade" varchar(20);--> statement-breakpoint
ALTER TABLE "wanjiedaoyou_temp_cultivators" ADD COLUMN "available_fates" jsonb;
ALTER TABLE "wanjiedaoyou_cultivators" ADD COLUMN "balance_notes" text;
CREATE TABLE "wanjiedaoyou_breakthrough_history" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"cultivator_id" uuid NOT NULL,
	"from_realm" varchar(20) NOT NULL,
	"from_stage" varchar(10) NOT NULL,
	"to_realm" varchar(20) NOT NULL,
	"to_stage" varchar(10) NOT NULL,
	"age" integer NOT NULL,
	"years_spent" integer NOT NULL,
	"story" text,
	"created_at" timestamp DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "wanjiedaoyou_retreat_records" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"cultivator_id" uuid NOT NULL,
	"realm" varchar(20) NOT NULL,
	"realm_stage" varchar(10) NOT NULL,
	"years" integer NOT NULL,
	"success" boolean DEFAULT false NOT NULL,
	"chance" double precision NOT NULL,
	"roll" double precision NOT NULL,
	"timestamp" timestamp DEFAULT now() NOT NULL,
	"modifiers" jsonb NOT NULL
);
--> statement-breakpoint
ALTER TABLE "wanjiedaoyou_cultivators" ADD COLUMN "closed_door_years_total" integer DEFAULT 0;--> statement-breakpoint
ALTER TABLE "wanjiedaoyou_breakthrough_history" ADD CONSTRAINT "wanjiedaoyou_breakthrough_history_cultivator_id_wanjiedaoyou_cultivators_id_fk" FOREIGN KEY ("cultivator_id") REFERENCES "public"."wanjiedaoyou_cultivators"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "wanjiedaoyou_retreat_records" ADD CONSTRAINT "wanjiedaoyou_retreat_records_cultivator_id_wanjiedaoyou_cultivators_id_fk" FOREIGN KEY ("cultivator_id") REFERENCES "public"."wanjiedaoyou_cultivators"("id") ON DELETE cascade ON UPDATE no action;
ALTER TABLE "wanjiedaoyou_cultivators" ADD COLUMN "status" varchar(20) DEFAULT 'active' NOT NULL;--> statement-breakpoint
ALTER TABLE "wanjiedaoyou_cultivators" ADD COLUMN "died_at" timestamp;
ALTER TABLE "wanjiedaoyou_battle_records" ADD COLUMN "challenge_type" varchar(20);--> statement-breakpoint
ALTER TABLE "wanjiedaoyou_battle_records" ADD COLUMN "opponent_cultivator_id" uuid;--> statement-breakpoint
ALTER TABLE "wanjiedaoyou_battle_records" ADD CONSTRAINT "wanjiedaoyou_battle_records_opponent_cultivator_id_wanjiedaoyou_cultivators_id_fk" FOREIGN KEY ("opponent_cultivator_id") REFERENCES "public"."wanjiedaoyou_cultivators"("id") ON DELETE set null ON UPDATE no action;
CREATE TABLE "wanjiedaoyou_materials" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"cultivator_id" uuid NOT NULL,
	"name" varchar(100) NOT NULL,
	"type" varchar(20) NOT NULL,
	"rank" varchar(20) NOT NULL,
	"element" varchar(10),
	"description" text,
	"details" jsonb DEFAULT '{}'::jsonb,
	"quantity" integer DEFAULT 1 NOT NULL,
	"created_at" timestamp DEFAULT now()
);
--> statement-breakpoint
ALTER TABLE "wanjiedaoyou_cultivators" ADD COLUMN "spirit_stones" integer DEFAULT 0 NOT NULL;--> statement-breakpoint
ALTER TABLE "wanjiedaoyou_materials" ADD CONSTRAINT "wanjiedaoyou_materials_cultivator_id_wanjiedaoyou_cultivators_id_fk" FOREIGN KEY ("cultivator_id") REFERENCES "public"."wanjiedaoyou_cultivators"("id") ON DELETE cascade ON UPDATE no action;
ALTER TABLE "wanjiedaoyou_artifacts" ADD COLUMN "quality" varchar(20) DEFAULT '鍑″搧' NOT NULL;--> statement-breakpoint
ALTER TABLE "wanjiedaoyou_artifacts" ADD COLUMN "required_realm" varchar(20) DEFAULT '缁冩皵' NOT NULL;
ALTER TABLE "wanjiedaoyou_artifacts" ADD COLUMN "prompt" varchar(200) DEFAULT '' NOT NULL;--> statement-breakpoint
ALTER TABLE "wanjiedaoyou_artifacts" ADD COLUMN "description" text;--> statement-breakpoint
ALTER TABLE "wanjiedaoyou_consumables" ADD COLUMN "prompt" varchar(200) DEFAULT '' NOT NULL;--> statement-breakpoint
ALTER TABLE "wanjiedaoyou_consumables" ADD COLUMN "quality" varchar(20) DEFAULT '鍑″搧' NOT NULL;--> statement-breakpoint
ALTER TABLE "wanjiedaoyou_consumables" ADD COLUMN "description" text;
ALTER TABLE "wanjiedaoyou_cultivators" ADD COLUMN "last_yield_at" timestamp DEFAULT now();
ALTER TABLE "wanjiedaoyou_skills" ADD COLUMN "description" text;
ALTER TABLE "wanjiedaoyou_cultivators" ADD COLUMN "title" varchar(50);
ALTER TABLE "wanjiedaoyou_consumables" ADD COLUMN "quantity" integer DEFAULT 1 NOT NULL;
ALTER TABLE "wanjiedaoyou_skills" ADD COLUMN "prompt" text DEFAULT '' NOT NULL;
ALTER TABLE "wanjiedaoyou_artifacts" ADD COLUMN "score" integer DEFAULT 0 NOT NULL;--> statement-breakpoint
ALTER TABLE "wanjiedaoyou_consumables" ADD COLUMN "score" integer DEFAULT 0 NOT NULL;--> statement-breakpoint
ALTER TABLE "wanjiedaoyou_skills" ADD COLUMN "score" integer DEFAULT 0 NOT NULL;
CREATE TABLE "wanjiedaoyou_mails" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"cultivator_id" uuid NOT NULL,
	"title" varchar(200) NOT NULL,
	"content" text NOT NULL,
	"type" varchar(20) DEFAULT 'system' NOT NULL,
	"attachments" jsonb,
	"is_read" boolean DEFAULT false NOT NULL,
	"is_claimed" boolean DEFAULT false NOT NULL,
	"created_at" timestamp DEFAULT now() NOT NULL
);
--> statement-breakpoint
ALTER TABLE "wanjiedaoyou_mails" ADD CONSTRAINT "wanjiedaoyou_mails_cultivator_id_wanjiedaoyou_cultivators_id_fk" FOREIGN KEY ("cultivator_id") REFERENCES "public"."wanjiedaoyou_cultivators"("id") ON DELETE cascade ON UPDATE no action;
CREATE TABLE "wanjiedaoyou_dungeon_histories" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"cultivator_id" uuid NOT NULL,
	"theme" varchar(100) NOT NULL,
	"result" jsonb NOT NULL,
	"log" text NOT NULL,
	"created_at" timestamp DEFAULT now() NOT NULL
);
--> statement-breakpoint
ALTER TABLE "wanjiedaoyou_dungeon_histories" ADD CONSTRAINT "wanjiedaoyou_dungeon_histories_cultivator_id_wanjiedaoyou_cultivators_id_fk" FOREIGN KEY ("cultivator_id") REFERENCES "public"."wanjiedaoyou_cultivators"("id") ON DELETE cascade ON UPDATE no action;
ALTER TABLE "wanjiedaoyou_cultivators" ADD COLUMN "persistent_statuses" jsonb DEFAULT '[]'::jsonb;
ALTER TABLE "wanjiedaoyou_cultivators" ADD COLUMN "cultivation_progress" jsonb DEFAULT '{}'::jsonb;
ALTER TABLE "wanjiedaoyou_dungeon_histories" ADD COLUMN "real_gains" jsonb;
ALTER TABLE "wanjiedaoyou_artifacts" ADD COLUMN "passive_traits" jsonb DEFAULT '[]'::jsonb;--> statement-breakpoint
ALTER TABLE "wanjiedaoyou_cultivation_techniques" ADD COLUMN "passive_traits" jsonb DEFAULT '[]'::jsonb;
ALTER TABLE "wanjiedaoyou_artifacts" ADD COLUMN "effects" jsonb DEFAULT '[]'::jsonb;--> statement-breakpoint
ALTER TABLE "wanjiedaoyou_consumables" ADD COLUMN "effects" jsonb DEFAULT '[]'::jsonb;--> statement-breakpoint
ALTER TABLE "wanjiedaoyou_cultivation_techniques" ADD COLUMN "effects" jsonb DEFAULT '[]'::jsonb;--> statement-breakpoint
ALTER TABLE "wanjiedaoyou_pre_heaven_fates" ADD COLUMN "effects" jsonb DEFAULT '[]'::jsonb;--> statement-breakpoint
ALTER TABLE "wanjiedaoyou_skills" ADD COLUMN "effects" jsonb DEFAULT '[]'::jsonb;--> statement-breakpoint
ALTER TABLE "wanjiedaoyou_artifacts" DROP COLUMN "bonus";--> statement-breakpoint
ALTER TABLE "wanjiedaoyou_artifacts" DROP COLUMN "special_effects";--> statement-breakpoint
ALTER TABLE "wanjiedaoyou_artifacts" DROP COLUMN "curses";--> statement-breakpoint
ALTER TABLE "wanjiedaoyou_artifacts" DROP COLUMN "passive_traits";--> statement-breakpoint
ALTER TABLE "wanjiedaoyou_consumables" DROP COLUMN "effect";--> statement-breakpoint
ALTER TABLE "wanjiedaoyou_cultivation_techniques" DROP COLUMN "bonus";--> statement-breakpoint
ALTER TABLE "wanjiedaoyou_cultivation_techniques" DROP COLUMN "passive_traits";--> statement-breakpoint
ALTER TABLE "wanjiedaoyou_pre_heaven_fates" DROP COLUMN "type";--> statement-breakpoint
ALTER TABLE "wanjiedaoyou_pre_heaven_fates" DROP COLUMN "attribute_mod";--> statement-breakpoint
ALTER TABLE "wanjiedaoyou_skills" DROP COLUMN "type";--> statement-breakpoint
ALTER TABLE "wanjiedaoyou_skills" DROP COLUMN "power";--> statement-breakpoint
ALTER TABLE "wanjiedaoyou_skills" DROP COLUMN "effect";--> statement-breakpoint
ALTER TABLE "wanjiedaoyou_skills" DROP COLUMN "duration";
DROP TABLE "wanjiedaoyou_temp_cultivators" CASCADE;--> statement-breakpoint
ALTER TABLE "wanjiedaoyou_consumables" ADD COLUMN "details" jsonb;
ALTER TABLE "wanjiedaoyou_cultivation_techniques" ADD COLUMN "description" text;
CREATE TABLE "wanjiedaoyou_admin_message_templates" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"channel" varchar(20) NOT NULL,
	"name" varchar(120) NOT NULL,
	"subject_template" varchar(300),
	"content_template" text NOT NULL,
	"default_payload" jsonb DEFAULT '{}'::jsonb NOT NULL,
	"status" varchar(20) DEFAULT 'active' NOT NULL,
	"created_by" uuid NOT NULL,
	"updated_by" uuid NOT NULL,
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL
);
CREATE TABLE "wanjiedaoyou_auction_listings" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"seller_id" uuid NOT NULL,
	"seller_name" varchar(100) NOT NULL,
	"item_type" varchar(20) NOT NULL,
	"item_id" uuid NOT NULL,
	"item_snapshot" jsonb NOT NULL,
	"price" integer NOT NULL,
	"status" varchar(20) DEFAULT 'active' NOT NULL,
	"created_at" timestamp DEFAULT now() NOT NULL,
	"expires_at" timestamp NOT NULL,
	"sold_at" timestamp
);
--> statement-breakpoint
ALTER TABLE "wanjiedaoyou_auction_listings" ADD CONSTRAINT "wanjiedaoyou_auction_listings_seller_id_wanjiedaoyou_cultivators_id_fk" FOREIGN KEY ("seller_id") REFERENCES "public"."wanjiedaoyou_cultivators"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
CREATE INDEX "auction_status_expires_idx" ON "wanjiedaoyou_auction_listings" USING btree ("status","expires_at");--> statement-breakpoint
CREATE INDEX "auction_seller_status_idx" ON "wanjiedaoyou_auction_listings" USING btree ("seller_id","status");--> statement-breakpoint
CREATE INDEX "auction_item_type_idx" ON "wanjiedaoyou_auction_listings" USING btree ("item_type");
CREATE TABLE "wanjiedaoyou_feedbacks" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"user_id" uuid NOT NULL,
	"cultivator_id" uuid,
	"type" varchar(20) NOT NULL,
	"content" text NOT NULL,
	"status" varchar(20) DEFAULT 'pending' NOT NULL,
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL
);
--> statement-breakpoint
ALTER TABLE "wanjiedaoyou_feedbacks" ADD CONSTRAINT "wanjiedaoyou_feedbacks_cultivator_id_wanjiedaoyou_cultivators_id_fk" FOREIGN KEY ("cultivator_id") REFERENCES "public"."wanjiedaoyou_cultivators"("id") ON DELETE set null ON UPDATE no action;--> statement-breakpoint
CREATE INDEX "feedback_user_id_idx" ON "wanjiedaoyou_feedbacks" USING btree ("user_id");--> statement-breakpoint
CREATE INDEX "feedback_status_idx" ON "wanjiedaoyou_feedbacks" USING btree ("status");--> statement-breakpoint
CREATE INDEX "feedback_type_idx" ON "wanjiedaoyou_feedbacks" USING btree ("type");--> statement-breakpoint
CREATE INDEX "feedback_created_at_idx" ON "wanjiedaoyou_feedbacks" USING btree ("created_at");
DROP INDEX "auction_status_expires_idx";--> statement-breakpoint
DROP INDEX "auction_item_type_idx";--> statement-breakpoint
DROP INDEX "feedback_user_id_idx";--> statement-breakpoint
DROP INDEX "feedback_status_idx";--> statement-breakpoint
DROP INDEX "feedback_type_idx";--> statement-breakpoint
DROP INDEX "feedback_created_at_idx";--> statement-breakpoint
CREATE INDEX "admin_templates_channel_status_created_idx" ON "wanjiedaoyou_admin_message_templates" USING btree ("channel","status","created_at");--> statement-breakpoint
CREATE INDEX "artifacts_cultivator_idx" ON "wanjiedaoyou_artifacts" USING btree ("cultivator_id");--> statement-breakpoint
CREATE INDEX "artifacts_score_idx" ON "wanjiedaoyou_artifacts" USING btree ("score");--> statement-breakpoint
CREATE INDEX "auction_status_expires_created_idx" ON "wanjiedaoyou_auction_listings" USING btree ("status","expires_at","created_at");--> statement-breakpoint
CREATE INDEX "auction_status_expires_price_idx" ON "wanjiedaoyou_auction_listings" USING btree ("status","expires_at","price");--> statement-breakpoint
CREATE INDEX "auction_status_expires_item_type_idx" ON "wanjiedaoyou_auction_listings" USING btree ("status","expires_at","item_type");--> statement-breakpoint
CREATE INDEX "battle_records_cultivator_created_idx" ON "wanjiedaoyou_battle_records" USING btree ("cultivator_id","created_at");--> statement-breakpoint
CREATE INDEX "battle_records_opponent_created_idx" ON "wanjiedaoyou_battle_records" USING btree ("opponent_cultivator_id","created_at");--> statement-breakpoint
CREATE INDEX "breakthrough_history_cultivator_created_idx" ON "wanjiedaoyou_breakthrough_history" USING btree ("cultivator_id","created_at");--> statement-breakpoint
CREATE INDEX "consumables_cultivator_idx" ON "wanjiedaoyou_consumables" USING btree ("cultivator_id");--> statement-breakpoint
CREATE INDEX "consumables_cultivator_name_quality_idx" ON "wanjiedaoyou_consumables" USING btree ("cultivator_id","name","quality");--> statement-breakpoint
CREATE INDEX "consumables_score_idx" ON "wanjiedaoyou_consumables" USING btree ("score");--> statement-breakpoint
CREATE INDEX "cultivation_techniques_cultivator_idx" ON "wanjiedaoyou_cultivation_techniques" USING btree ("cultivator_id");--> statement-breakpoint
CREATE INDEX "cultivators_user_status_updated_idx" ON "wanjiedaoyou_cultivators" USING btree ("user_id","status","updated_at");--> statement-breakpoint
CREATE INDEX "cultivators_status_created_idx" ON "wanjiedaoyou_cultivators" USING btree ("status","created_at");--> statement-breakpoint
CREATE INDEX "dungeon_histories_cultivator_created_idx" ON "wanjiedaoyou_dungeon_histories" USING btree ("cultivator_id","created_at");--> statement-breakpoint
CREATE INDEX "feedback_user_created_at_idx" ON "wanjiedaoyou_feedbacks" USING btree ("user_id","created_at");--> statement-breakpoint
CREATE INDEX "feedback_status_type_created_at_idx" ON "wanjiedaoyou_feedbacks" USING btree ("status","type","created_at");--> statement-breakpoint
CREATE INDEX "mails_cultivator_created_idx" ON "wanjiedaoyou_mails" USING btree ("cultivator_id","created_at");--> statement-breakpoint
CREATE INDEX "mails_cultivator_is_read_created_idx" ON "wanjiedaoyou_mails" USING btree ("cultivator_id","is_read","created_at");--> statement-breakpoint
CREATE INDEX "materials_cultivator_idx" ON "wanjiedaoyou_materials" USING btree ("cultivator_id");--> statement-breakpoint
CREATE INDEX "materials_cultivator_name_idx" ON "wanjiedaoyou_materials" USING btree ("cultivator_id","name");--> statement-breakpoint
CREATE INDEX "materials_cultivator_name_rank_idx" ON "wanjiedaoyou_materials" USING btree ("cultivator_id","name","rank");--> statement-breakpoint
CREATE INDEX "pre_heaven_fates_cultivator_idx" ON "wanjiedaoyou_pre_heaven_fates" USING btree ("cultivator_id");--> statement-breakpoint
CREATE INDEX "retreat_records_cultivator_timestamp_idx" ON "wanjiedaoyou_retreat_records" USING btree ("cultivator_id","timestamp");--> statement-breakpoint
CREATE INDEX "skills_cultivator_idx" ON "wanjiedaoyou_skills" USING btree ("cultivator_id");--> statement-breakpoint
CREATE INDEX "skills_score_idx" ON "wanjiedaoyou_skills" USING btree ("score");--> statement-breakpoint
CREATE INDEX "spiritual_roots_cultivator_idx" ON "wanjiedaoyou_spiritual_roots" USING btree ("cultivator_id");
ALTER TABLE "wanjiedaoyou_cultivation_techniques" ADD COLUMN "score" integer DEFAULT 0 NOT NULL;--> statement-breakpoint
CREATE INDEX "cultivation_techniques_score_idx" ON "wanjiedaoyou_cultivation_techniques" USING btree ("score");
CREATE TABLE "wanjiedaoyou_bet_battles" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"creator_id" uuid NOT NULL,
	"creator_name" varchar(100) NOT NULL,
	"status" varchar(20) DEFAULT 'pending' NOT NULL,
	"min_realm" varchar(20) NOT NULL,
	"max_realm" varchar(20) NOT NULL,
	"creator_stake_snapshot" jsonb NOT NULL,
	"challenger_stake_snapshot" jsonb,
	"challenger_id" uuid,
	"challenger_name" varchar(100),
	"winner_cultivator_id" uuid,
	"battle_record_id" uuid,
	"expires_at" timestamp NOT NULL,
	"matched_at" timestamp,
	"settled_at" timestamp,
	"created_at" timestamp DEFAULT now() NOT NULL
);
--> statement-breakpoint
ALTER TABLE "wanjiedaoyou_bet_battles" ADD CONSTRAINT "wanjiedaoyou_bet_battles_creator_id_wanjiedaoyou_cultivators_id_fk" FOREIGN KEY ("creator_id") REFERENCES "public"."wanjiedaoyou_cultivators"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "wanjiedaoyou_bet_battles" ADD CONSTRAINT "wanjiedaoyou_bet_battles_challenger_id_wanjiedaoyou_cultivators_id_fk" FOREIGN KEY ("challenger_id") REFERENCES "public"."wanjiedaoyou_cultivators"("id") ON DELETE set null ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "wanjiedaoyou_bet_battles" ADD CONSTRAINT "wanjiedaoyou_bet_battles_winner_cultivator_id_wanjiedaoyou_cultivators_id_fk" FOREIGN KEY ("winner_cultivator_id") REFERENCES "public"."wanjiedaoyou_cultivators"("id") ON DELETE set null ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "wanjiedaoyou_bet_battles" ADD CONSTRAINT "wanjiedaoyou_bet_battles_battle_record_id_wanjiedaoyou_battle_records_id_fk" FOREIGN KEY ("battle_record_id") REFERENCES "public"."wanjiedaoyou_battle_records"("id") ON DELETE set null ON UPDATE no action;--> statement-breakpoint
CREATE INDEX "bet_battles_status_expires_idx" ON "wanjiedaoyou_bet_battles" USING btree ("status","expires_at");--> statement-breakpoint
CREATE INDEX "bet_battles_creator_status_idx" ON "wanjiedaoyou_bet_battles" USING btree ("creator_id","status");--> statement-breakpoint
CREATE INDEX "bet_battles_status_created_idx" ON "wanjiedaoyou_bet_battles" USING btree ("status","created_at");
ALTER TABLE "wanjiedaoyou_bet_battles" ADD COLUMN "taunt" varchar(20);
CREATE TABLE "wanjiedaoyou_redeem_code_claims" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"redeem_code_id" uuid NOT NULL,
	"user_id" uuid NOT NULL,
	"cultivator_id" uuid NOT NULL,
	"mail_id" uuid NOT NULL,
	"created_at" timestamp DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "wanjiedaoyou_redeem_codes" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"code" varchar(64) NOT NULL,
	"reward_preset_id" varchar(100) NOT NULL,
	"mail_title" varchar(200) NOT NULL,
	"mail_content" text NOT NULL,
	"status" varchar(20) DEFAULT 'active' NOT NULL,
	"total_limit" integer,
	"claimed_count" integer DEFAULT 0 NOT NULL,
	"starts_at" timestamp,
	"ends_at" timestamp,
	"created_by" uuid NOT NULL,
	"updated_by" uuid NOT NULL,
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL
);
--> statement-breakpoint
ALTER TABLE "wanjiedaoyou_redeem_code_claims" ADD CONSTRAINT "wanjiedaoyou_redeem_code_claims_redeem_code_id_wanjiedaoyou_redeem_codes_id_fk" FOREIGN KEY ("redeem_code_id") REFERENCES "public"."wanjiedaoyou_redeem_codes"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "wanjiedaoyou_redeem_code_claims" ADD CONSTRAINT "wanjiedaoyou_redeem_code_claims_cultivator_id_wanjiedaoyou_cultivators_id_fk" FOREIGN KEY ("cultivator_id") REFERENCES "public"."wanjiedaoyou_cultivators"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "wanjiedaoyou_redeem_code_claims" ADD CONSTRAINT "wanjiedaoyou_redeem_code_claims_mail_id_wanjiedaoyou_mails_id_fk" FOREIGN KEY ("mail_id") REFERENCES "public"."wanjiedaoyou_mails"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
CREATE UNIQUE INDEX "redeem_code_claims_code_user_unique" ON "wanjiedaoyou_redeem_code_claims" USING btree ("redeem_code_id","user_id");--> statement-breakpoint
CREATE INDEX "redeem_code_claims_user_idx" ON "wanjiedaoyou_redeem_code_claims" USING btree ("user_id");--> statement-breakpoint
CREATE INDEX "redeem_code_claims_code_idx" ON "wanjiedaoyou_redeem_code_claims" USING btree ("redeem_code_id");--> statement-breakpoint
CREATE UNIQUE INDEX "redeem_codes_code_unique" ON "wanjiedaoyou_redeem_codes" USING btree ("code");--> statement-breakpoint
CREATE INDEX "redeem_codes_status_created_idx" ON "wanjiedaoyou_redeem_codes" USING btree ("status","created_at");--> statement-breakpoint
CREATE INDEX "redeem_codes_created_idx" ON "wanjiedaoyou_redeem_codes" USING btree ("created_at");
CREATE TABLE "wanjiedaoyou_dungeon_runs" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"cultivator_id" uuid NOT NULL,
	"map_node_id" varchar(100) NOT NULL,
	"status" varchar(20) DEFAULT 'ACTIVE' NOT NULL,
	"current_layer" integer DEFAULT 1 NOT NULL,
	"max_layer" integer DEFAULT 10 NOT NULL,
	"danger_score" integer DEFAULT 10 NOT NULL,
	"run_state" jsonb NOT NULL,
	"granted_gains" jsonb DEFAULT '[]'::jsonb NOT NULL,
	"version" integer DEFAULT 1 NOT NULL,
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL,
	"ended_at" timestamp
);
--> statement-breakpoint
ALTER TABLE "wanjiedaoyou_dungeon_runs" ADD CONSTRAINT "wanjiedaoyou_dungeon_runs_cultivator_id_wanjiedaoyou_cultivators_id_fk" FOREIGN KEY ("cultivator_id") REFERENCES "public"."wanjiedaoyou_cultivators"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
CREATE INDEX "dungeon_runs_cultivator_status_updated_idx" ON "wanjiedaoyou_dungeon_runs" USING btree ("cultivator_id","status","updated_at");--> statement-breakpoint
CREATE INDEX "dungeon_runs_status_updated_idx" ON "wanjiedaoyou_dungeon_runs" USING btree ("status","updated_at");
