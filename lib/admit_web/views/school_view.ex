defmodule AdmitWeb.SchoolView do
  use AdmitWeb, :view

  def level_options do
    [Nursery: "nursery", Primary: "primary", Secondary: "secondary"]
  end
end
