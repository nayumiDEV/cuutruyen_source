MeiliSearch::Rails.configuration = {
  meilisearch_host: ENV.fetch("MEILISEARCH_URL") { "http://meilisearch:7700" }
}
