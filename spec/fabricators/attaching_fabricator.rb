Fabricator(:attaching) do
  attachment { Fabricate(:attachment) }
  document { Fabricate(:post) }
end
