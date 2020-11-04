# テーブル設計

## users テーブル

| Column                | Type    | Options     |
| --------------------- | ------- | ----------- |
| nickname              | string  | null: false |
| email                 | string  | null: false |
| password              | string  | null: false |
| last_name             | string  | null: false |
| first_name            | string  | null: false |
| last_name (katakana)  | string  | null: false |
| first_name (katakana) | string  | null: false |
| birth_year            | integer | null: false |
| birth_month           | integer | null: false |
| birth_day             | integer | null: false |

### Association

- has_many :items

## items テーブル

| Column             | Type        | Options                        |
| ------------------ | ----------- | ------------------------------ |
| name               | string      | null: false                    |
| description        | text        | null: false                    |
| category_id        | integer     | null: false                    |
| status_id          | integer     | null: false                    |
| shipping_id        | integer     | null: false                    |
| item_prefecture_id | integer     | null: false                    |
| transport_days_id  | integer     | null: false                    |
| user               | references  | null: false, foreign_key: true |

### Association

- belongs_to :user
- has_one :buyer

## buyers テーブル

| Column         | Type       | Options                        |
| -------------- | ---------- | ------------------------------ |
| postal_code    | integer    | null: false                    |
| prefecture_id  | integer    | null: false                    |
| city           | string     | null: false                    |
| address        | string     | null: false                    |
| building       | string     |                                |
| phone_num      | integer    | null: false                    |
| item           | references | null: false, foreign_key: true |

### Association

- belongs_to :item
