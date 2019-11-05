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

public class Velocity {

  /* Members */

  private Vector2 value;

  /* Constructors */

  public Velocity(Vector2 value) {
    this.value = Objects.requireNonNull(value);
  }

  public Velocity() {
    this.value = new Vector2();
  }

  public Velocity(Velocity other) {
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
    if (!(other0 instanceof Velocity)) {
      return false;
    }
    Velocity other = (Velocity) other0;
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

  public static final Factory<Velocity> FACTORY = new Factory<Velocity>() {
    @Override
    public Velocity create() {
      return new Velocity();
    }

    @Override
    public Velocity create(Velocity other) {
      return new Velocity(other);
    }

    @Override
    public TypeExpr typeExpr() {
      ScopedName scopedName = new ScopedName("canine.api", "Velocity");
      ArrayList<TypeExpr> params = new ArrayList<>();
      return new TypeExpr(TypeRef.reference(scopedName), params);
    }
    @Override
    public JsonBinding<Velocity> jsonBinding() {
      return Velocity.jsonBinding();
    }
  };

  /* Json serialization */

  public static JsonBinding<Velocity> jsonBinding() {
    final JsonBinding<Vector2> _binding = Vector2.jsonBinding();
    final Factory<Velocity> _factory = FACTORY;

    return new JsonBinding<Velocity>() {
      @Override
      public Factory<Velocity> factory() {
        return _factory;
      }

      @Override
      public JsonElement toJson(Velocity _value) {
        return _binding.toJson(_value.value);
      }

      @Override
      public Velocity fromJson(JsonElement _json) {
        return new Velocity(_binding.fromJson(_json));
      }
    };
  }
}
