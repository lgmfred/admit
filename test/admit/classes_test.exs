defmodule Admit.ClassesTest do
  use Admit.DataCase

  alias Admit.Classes

  describe "classes" do
    alias Admit.Classes.Class

    import Admit.ClassesFixtures
    import Admit.SchoolsFixtures

    @invalid_attrs %{description: nil, name: nil}

    test "list_classes/0 returns all classes" do
      school = school_fixture()
      class = class_fixture(school_id: school.id)
      assert Classes.list_classes() == [class]
    end

    test "get_class!/1 returns the class with given id" do
      school = school_fixture()
      class = class_fixture(school_id: school.id)
      assert Classes.get_class!(class.id) == class
    end

    test "create_class/1 with valid data creates a class" do
      school = school_fixture()
      valid_attrs = %{school_id: school.id, description: "some description", name: "some name"}

      assert {:ok, %Class{} = class} = Classes.create_class(valid_attrs)
      assert class.description == "some description"
      assert class.name == "some name"
    end

    test "create_class/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Classes.create_class(@invalid_attrs)
    end

    test "update_class/2 with valid data updates the class" do
      school = school_fixture()
      class = class_fixture(school_id: school.id)
      update_attrs = %{description: "some updated description", name: "some updated name"}

      assert {:ok, %Class{} = class} = Classes.update_class(class, update_attrs)
      assert class.description == "some updated description"
      assert class.name == "some updated name"
    end

    test "update_class/2 with invalid data returns error changeset" do
      school = school_fixture()
      class = class_fixture(school_id: school.id)
      assert {:error, %Ecto.Changeset{}} = Classes.update_class(class, @invalid_attrs)
      assert class == Classes.get_class!(class.id)
    end

    test "delete_class/1 deletes the class" do
      school = school_fixture()
      class = class_fixture(school_id: school.id)
      assert {:ok, %Class{}} = Classes.delete_class(class)
      assert_raise Ecto.NoResultsError, fn -> Classes.get_class!(class.id) end
    end

    test "change_class/1 returns a class changeset" do
      school = school_fixture()
      class = class_fixture(school_id: school.id)
      assert %Ecto.Changeset{} = Classes.change_class(class)
    end
  end
end
