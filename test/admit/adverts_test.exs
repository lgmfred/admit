defmodule Admit.AdvertsTest do
  use Admit.DataCase

  alias Admit.Adverts

  describe "adverts" do
    alias Admit.Adverts.Advert

    import Admit.AdvertsFixtures
    import Admit.AccountsFixtures
    import Admit.SchoolsFixtures
    import Admit.ClassesFixtures

    @invalid_attrs %{deadline: nil, description: nil, published_on: nil}

    test "list_adverts/0 returns all adverts" do
      school = school_fixture()
      class = class_fixture(school_id: school.id)

      advert = advert_fixture(%{school_id: school.id, class_id: class.id})
      assert Adverts.list_adverts() == [advert]
    end

    test "get_advert!/1 returns the advert with given id" do
      school = school_fixture()
      class = class_fixture(school_id: school.id)
      advert = advert_fixture(%{school_id: school.id, class_id: class.id})
      assert Adverts.get_advert!(advert.id) == advert
    end

    test "create_advert/1 with valid data creates a advert" do
      valid_attrs = %{
        deadline: ~D[2023-04-16],
        description: "some description",
        published_on: ~D[2023-04-16]
      }

      school = school_fixture()
      class = class_fixture(school_id: school.id)

      valid_attrs =
        valid_attrs
        |> Map.put(:school_id, school.id)
        |> Map.put(:class_id, class.id)

      assert {:ok, %Advert{} = advert} = Adverts.create_advert(valid_attrs)
      assert advert.deadline == ~D[2023-04-16]
      assert advert.description == "some description"
      assert advert.published_on == ~D[2023-04-16]
    end

    test "create_advert/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Adverts.create_advert(@invalid_attrs)
    end

    test "update_advert/2 with valid data updates the advert" do
      school = school_fixture()
      class = class_fixture(%{school_id: school.id})
      advert = advert_fixture(%{school_id: school.id, class_id: class.id})

      update_attrs = %{
        deadline: ~D[2023-04-17],
        description: "some updated description",
        published_on: ~D[2023-04-17]
      }

      assert {:ok, %Advert{} = advert} = Adverts.update_advert(advert, update_attrs)
      assert advert.deadline == ~D[2023-04-17]
      assert advert.description == "some updated description"
      assert advert.published_on == ~D[2023-04-17]
    end

    test "update_advert/2 with invalid data returns error changeset" do
      school = school_fixture()
      class = class_fixture(school_id: school.id)
      advert = advert_fixture(%{school_id: school.id, class_id: class.id})
      assert {:error, %Ecto.Changeset{}} = Adverts.update_advert(advert, @invalid_attrs)
      assert advert == Adverts.get_advert!(advert.id)
    end

    test "delete_advert/1 deletes the advert" do
      school = school_fixture()
      class = class_fixture(school_id: school.id)
      advert = advert_fixture(%{school_id: school.id, class_id: class.id})
      assert {:ok, %Advert{}} = Adverts.delete_advert(advert)
      assert_raise Ecto.NoResultsError, fn -> Adverts.get_advert!(advert.id) end
    end

    test "change_advert/1 returns a advert changeset" do
      school = school_fixture()
      class = class_fixture(school_id: school.id)
      advert = advert_fixture(%{school_id: school.id, class_id: class.id})
      assert %Ecto.Changeset{} = Adverts.change_advert(advert)
    end
  end
end
