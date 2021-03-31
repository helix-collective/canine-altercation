/* @generated from adl module canine.api */

package com.canine.game.adl.canine.api;

import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import org.adl.runtime.Factory;
import org.adl.runtime.JsonBinding;
import org.adl.runtime.sys.adlast.ScopedName;
import org.adl.runtime.sys.adlast.TypeExpr;
import org.adl.runtime.sys.adlast.TypeRef;
import java.util.ArrayList;
import java.util.Objects;

public class Position {

  /* Members */

  private Vector2 value;

  /* Constructors */

  public Position(Vector2 value) {
    this.value = Objects.requireNonNull(value);
  }

  public Position() {
    this.value = new Vector2();
  }

  public Position(Position other) {
    this.value = Vector2.FACTORY.create(other.value);
  }

  /* Accessors and mutators */

  public Vector2 getValue() {
    return value;
  }

  public void setValue(Vector2 value) {
    this.value = Objects.requireNonNull(value);
  }

  /* Object level helpers */

  @Override
  public boolean equals(Object other0) {
    if (!(other0 instanceof Position)) {
      return false;
    }
    Position other = (Position) other0;
    return
      value.equals(other.value);
  }

  @Override
  public int hashCode() {
    int _result = 1;
    _result = _result * 37 + value.hashCode();
    return _result;
  }

  /* Factory for construction of generic values */

  public static final Factory<Position> FACTORY = new Factory<Position>() {
    @Override
    public Position create() {
      return new Position();
    }

    @Override
    public Position create(Position other) {
      return new Position(other);
    }

    @Override
    public TypeExpr typeExpr() {
      ScopedName scopedName = new ScopedName("canine.api", "Position");
      ArrayList<TypeExpr> params = new ArrayList<>();
      return new TypeExpr(TypeRef.reference(scopedName), params);
    }
    @Override
    public JsonBinding<Position> jsonBinding() {
      return Position.jsonBinding();
    }
  };

  /* Json serialization */

  public static JsonBinding<Position> jsonBinding() {
    final JsonBinding<Vector2> _binding = Vector2.jsonBinding();
    final Factory<Position> _factory = FACTORY;

    return new JsonBinding<Position>() {
      @Override
      public Factory<Position> factory() {
        return _factory;
      }

      @Override
      public JsonElement toJson(Position _value) {
        return _binding.toJson(_value.value);
      }

      @Override
      public Position fromJson(JsonElement _json) {
        return new Position(_binding.fromJson(_json));
      }
    };
  }
}
